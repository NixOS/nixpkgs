# Visual Studio Code {#visual-studio-code}

_For the free distribution Visual Studio Code (VSC) without MS branding/telemetry see [vscodium](https://nixos.wiki/wiki/VSCodium)_

To install VSC just add it to `systemPackages`:

```nix
{ environment.systemPackages = with pkgs; [ vscode ]; }
```

You can also install it through [Home Manager](https://nix-community.github.io/home-manager/options.html#opt-programs.vscode.enable):

```nix
{ programs.vscode.enable = true; }
```

## Installing Extensions Through Nix

There are two ways of installing VSC extensions through Nix, and you'll typically use both. The first is to install them as [Nix packages](https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&query=vscode-extensions). This is especially important for extensions that require external dependencies, such as `vsliveshare`. The second is to install them directly from the VSC marketplace, in the form of a list of attribute sets. The resulting list of extensions can be passed to both `vscodeExtensions` and the `extensions` option from HM. It's recommended to use `vscodeExtensions` though, since the HM option uses an older method of handling extensions, which is not as reliable (see this [issue](https://github.com/nix-community/home-manager/issues/1260)).

The snippet below shows how both types of extensions can easily be combined:

```nix
let
  extensions = (with pkgs.vscode-extensions; [
    bbenoist.Nix
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    name = "remote-ssh-edit";
    publisher = "ms-vscode-remote";
    version = "0.47.2";
    sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
  }];
  my-vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in
{
  environment.systemPackages = [
    my-vscode
  ];
}
```

### Obtaining Marketplace Attribute Sets

The script at `https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/vscode.nix` makes updating marketplace extensions much more convenient. It takes a list of extensions on STDIN and attribute sets that you can paste into your Nix code. Here's how you can **generate Nix objects for all currently installed VSC extensions** if you want to painlessly migrate from installing extensions through VSC to having them managed by Nix.

```shell
$ code-insiders --list-extensions | pkgs/misc/vscode-extensions/update_exts.sh
these paths will be fetched (2.18 MiB download, 11.21 MiB unpacked):
  ...output omitted
  {
    name = "vscode-sql-formatter";
    publisher = "adpyke";
    version = "1.4.4";
    sha256 = "06q78hnq76mdkhsfpym2w23wg9wcpikpfgz07mxk1vnm9h3jm2l3";
  }
  {
    name = "vscode-theme-onelight";
    publisher = "akamud";
    version = "2.2.3";
    sha256 = "1mzd77sv6lb6kfv5fvdvzggs488q553cf752byrml981ys9r7khz";
  }
```

You can also generate objects based on whichever extension names you pass in, which is great for updating individual extensions already managed through Nix, or installing new extensions.

```shell
$ echo 'ms-toolsai.jupyter' | pkgs/misc/vscode-extensions/update_exts.sh
{
  name = "jupyter";
  publisher = "ms-toolsai";
  version = "2021.3.600686576";
  sha256 = "1nxcq1an3lqidfgfnadwa5nbx491vwynpf63bpf8b44b3f6h3f4n";
}
```

## Installing Extensions Through The VSC UI

You can also install extensions imperatively through the VSC UI, just like you would without Nix. The downside is that it typically doesn't work for extensions that ship pre-compiled binaries, such as `vsliveshare`. But, starting with NixOS 21.05, there are two new VSC variations, `vscode-fhs` and `vscodium-fhs`, which make it a lot easier to use the VSC UI to install extensions on a NixOS system. Both `*-fhs` variations utilize `buildFHSUserEnv` to launch the editor inside of a FHS compliant environment. This reintroduces directories such as /bin, /lib/, and /usr, which allows for extensions which ship pre-compiled binaries to work with little to no additional nixification.

NixOS:

```nix
{ environment.systemPackages = with pkgs; [ vscode-fhs ]; }
```

HM:

```nix
{
  programs.vscode.enable = true;
  # Add extension specific dependencies
  programs.vscode.package = pkgs.vscode-fhsWithPackages (ps: with ps; [ rustup zlib ]);
}
```

## Insiders

You can pass an `isInsiders` argument to the [VSC derivation](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/vscode.nix). This **only changes the name of the resulting command** and doesn't actually install the insiders version. Which version is installed depends entirely on the URL from which VSC is downloaded, most importantly the version included in the URL string. This version is hardcoded in the derivation, but you can override it.

```nix
{ pkgs, config, ... }:
let
  version = "latest";

  latest = (pkgs.vscode.override {
    isInsiders = true;
  }).overrideAttrs
    (_: rec {
      src = builtins.fetchurl {
        name = "VSCode_${version}_${plat}.${archive_fmt}";
        url = "https://vscode-update.azurewebsites.net/${version}/${plat}/insider";
        sha256 = "16qlgqfpz7pn52dw6r3xav4ly7rpl5lwck94vdpvzgld1ja9rpm0";
      };
    });

  finalPackage = (pkgs.vscode-with-extensions.override {
    vscode = latest;
    vscodeExtensions = with pkgs.vscode-extensions; [ ms-vsliveshare.vsliveshare ];
  }).overrideAttrs (old: {
    inherit (latest) pname version;
  });
in
{
  environment.systemPackages = [
    finalPackage
  ];
}
```

## VSC and Nix Shell

If you use Nix shells to create custom environments on a per project basis, you'll have to adjust your VSC workflow a little bit. There are two options for making sure that VSC uses the custom Nix environment and has access to whichever commands you've added.

- Start VSC from a running Nix shell: `code-insiders .`
- Use the [`nix-env-selector` extension](https://github.com/arrterian/nix-env-selector)
