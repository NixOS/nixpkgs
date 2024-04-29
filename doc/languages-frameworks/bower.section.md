# Bower {#sec-bower}

[Bower](https://bower.io) is a package manager for web site front-end components. Bower packages (comprising of build artifacts and sometimes sources) are stored in `git` repositories, typically on Github. The package registry is run by the Bower team with package metadata coming from the `bower.json` file within each package.

The end result of running Bower is a `bower_components` directory which can be included in the web app's build process.

Bower can be run interactively, by installing `nodePackages.bower`. More interestingly, the Bower components can be declared in a Nix derivation, with the help of `nodePackages.bower2nix`.

## bower2nix usage {#ssec-bower2nix-usage}

Suppose you have a `bower.json` with the following contents:

### Example bower.json {#ex-bowerJson}

```json
  "name": "my-web-app",
  "dependencies": {
    "angular": "~1.5.0",
    "bootstrap": "~3.3.6"
  }
```

Running `bower2nix` will produce something like the following output:

```nix
{ fetchbower, buildEnv }:
buildEnv { name = "bower-env"; ignoreCollisions = true; paths = [
  (fetchbower "angular" "1.5.3" "~1.5.0" "1749xb0firxdra4rzadm4q9x90v6pzkbd7xmcyjk6qfza09ykk9y")
  (fetchbower "bootstrap" "3.3.6" "~3.3.6" "1vvqlpbfcy0k5pncfjaiskj3y6scwifxygfqnw393sjfxiviwmbv")
  (fetchbower "jquery" "2.2.2" "1.9.1 - 2" "10sp5h98sqwk90y4k6hbdviwqzvzwqf47r3r51pakch5ii2y7js1")
]; }
```

Using the `bower2nix` command line arguments, the output can be redirected to a file. A name like `bower-packages.nix` would be fine.

The resulting derivation is a union of all the downloaded Bower packages (and their dependencies). To use it, they still need to be linked together by Bower, which is where `buildBowerComponents` is useful.

## buildBowerComponents function {#ssec-build-bower-components}

The function is implemented in [pkgs/development/bower-modules/generic/default.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/bower-modules/generic/default.nix).

### Example buildBowerComponents {#ex-buildBowerComponents}

```nix
{
  bowerComponents = buildBowerComponents {
    name = "my-web-app";
    generated = ./bower-packages.nix; # note 1
    src = myWebApp; # note 2
  };
}
```

In ["buildBowerComponents" example](#ex-buildBowerComponents) the following arguments are of special significance to the function:

1. `generated` specifies the file which was created by {command}`bower2nix`.
2. `src` is your project's sources. It needs to contain a {file}`bower.json` file.

`buildBowerComponents` will run Bower to link together the output of `bower2nix`, resulting in a `bower_components` directory which can be used.

Here is an example of a web frontend build process using `gulp`. You might use `grunt`, or anything else.

### Example build script (gulpfile.js) {#ex-bowerGulpFile}

```javascript
var gulp = require('gulp');

gulp.task('default', [], function () {
  gulp.start('build');
});

gulp.task('build', [], function () {
  console.log("Just a dummy gulp build");
  gulp
    .src(["./bower_components/**/*"])
    .pipe(gulp.dest("./gulpdist/"));
});
```

### Example Full example — default.nix {#ex-buildBowerComponentsDefaultNix}

```nix
{ myWebApp ? { outPath = ./.; name = "myWebApp"; }
, pkgs ? import <nixpkgs> {}
}:

pkgs.stdenv.mkDerivation {
  name = "my-web-app-frontend";
  src = myWebApp;

  buildInputs = [ pkgs.nodePackages.gulp ];

  bowerComponents = pkgs.buildBowerComponents { # note 1
    name = "my-web-app";
    generated = ./bower-packages.nix;
    src = myWebApp;
  };

  buildPhase = ''
    cp --reflink=auto --no-preserve=mode -R $bowerComponents/bower_components . # note 2
    export HOME=$PWD # note 3
    ${pkgs.nodePackages.gulp}/bin/gulp build # note 4
  '';

  installPhase = "mv gulpdist $out";
}
```

A few notes about [Full example — `default.nix`](#ex-buildBowerComponentsDefaultNix):

1. The result of `buildBowerComponents` is an input to the frontend build.
2. Whether to symlink or copy the {file}`bower_components` directory depends on the build tool in use.
   In this case a copy is used to avoid {command}`gulp` silliness with permissions.
3. {command}`gulp` requires `HOME` to refer to a writeable directory.
4. The actual build command in this example is {command}`gulp`. Other tools could be used instead.

## Troubleshooting {#ssec-bower2nix-troubleshooting}

### ENOCACHE errors from buildBowerComponents {#enocache-errors-from-buildbowercomponents}

This means that Bower was looking for a package version which doesn't exist in the generated `bower-packages.nix`.

If `bower.json` has been updated, then run `bower2nix` again.

It could also be a bug in `bower2nix` or `fetchbower`. If possible, try reformulating the version specification in `bower.json`.
