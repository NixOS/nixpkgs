# R {#r}

## Installation {#installation}

Define an environment for R that contains all the libraries that you'd like to
use by adding the following snippet to your $HOME/.config/nixpkgs/config.nix file:

```nix
{
  packageOverrides =
    super:
    let
      self = super.pkgs;
    in
    {

      rEnv = super.rWrapper.override {
        packages = with self.rPackages; [
          devtools
          ggplot2
          reshape2
          yaml
          optparse
        ];
      };
    };
}
```

Then you can use `nix-env -f "<nixpkgs>" -iA rEnv` to install it into your user
profile. The set of available libraries can be discovered by running the
command `nix-env -f "<nixpkgs>" -qaP -A rPackages`. The first column from that
output is the name that has to be passed to rWrapper in the code snipped above.

However, if you'd like to add a file to your project source to make the
environment available for other contributors, you can create a `default.nix`
file like so:

```nix
with import <nixpkgs> { };
{
  myProject = stdenv.mkDerivation {
    name = "myProject";
    version = "1";
    src = if lib.inNixShell then null else nix;

    buildInputs = with rPackages; [
      R
      ggplot2
      knitr
    ];
  };
}
```
and then run `nix-shell .` to be dropped into a shell with those packages
available.

## RStudio {#rstudio}

RStudio uses a standard set of packages and ignores any custom R
environments or installed packages you may have.  To create a custom
environment, see `rstudioWrapper`, which functions similarly to
`rWrapper`:

```nix
{
  packageOverrides =
    super:
    let
      self = super.pkgs;
    in
    {

      rstudioEnv = super.rstudioWrapper.override {
        packages = with self.rPackages; [
          dplyr
          ggplot2
          reshape2
        ];
      };
    };
}
```

Then like above, `nix-env -f "<nixpkgs>" -iA rstudioEnv` will install
this into your user profile.

Alternatively, you can create a self-contained `shell.nix` without the need to
modify any configuration files:

```nix
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.rstudioWrapper.override {
  packages = with pkgs.rPackages; [
    dplyr
    ggplot2
    reshape2
  ];
}
```

Executing `nix-shell` will then drop you into an environment equivalent to the
one above. If you need additional packages just add them to the list and
re-enter the shell.

## Updating the package set {#updating-the-package-set}

There is a script and associated environment for regenerating the package
sets and synchronising the rPackages tree to the current CRAN and matching
BIOC release. These scripts are found in the `pkgs/development/r-modules`
directory and executed as follows:

```bash
nix-shell generate-shell.nix

Rscript generate-r-packages.R cran  > cran-packages.json.new
mv cran-packages.json.new cran-packages.json

Rscript generate-r-packages.R bioc  > bioc-packages.json.new
mv bioc-packages.json.new bioc-packages.json

Rscript generate-r-packages.R bioc-annotation > bioc-annotation-packages.json.new
mv bioc-annotation-packages.json.new bioc-annotation-packages.json

Rscript generate-r-packages.R bioc-experiment > bioc-experiment-packages.json.new
mv bioc-experiment-packages.json.new bioc-experiment-packages.json
```

`generate-r-packages.R <repo>` reads  `<repo>-packages.json`, therefore
the renaming.

The contents of a generated `*-packages.json` file will be used to
create a package derivation for each R package listed in the file.

Some packages require overrides to specify external dependencies or other
patches and special requirements. These overrides are specified in the
`pkgs/development/r-modules/default.nix` file. As the `*-packages.json`
contents are automatically generated it should not be edited and broken
builds should be addressed using overrides.
