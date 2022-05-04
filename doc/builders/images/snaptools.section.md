# pkgs.snapTools {#sec-pkgs-snapTools}

`pkgs.snapTools` is a set of functions for creating Snapcraft images. Snap and Snapcraft is not used to perform these operations.

## The makeSnap Function {#ssec-pkgs-snapTools-makeSnap-signature}

`makeSnap` takes a single named argument, `meta`. This argument mirrors [the upstream `snap.yaml` format](https://docs.snapcraft.io/snap-format) exactly.

The `base` should not be specified, as `makeSnap` will force set it.

Currently, `makeSnap` does not support creating GUI stubs.

## Build a Hello World Snap {#ssec-pkgs-snapTools-build-a-snap-hello}

The following expression packages GNU Hello as a Snapcraft snap.

``` {#ex-snapTools-buildSnap-hello .nix}
let
  inherit (import <nixpkgs> { }) snapTools hello;
in snapTools.makeSnap {
  meta = {
    name = "hello";
    summary = hello.meta.description;
    description = hello.meta.longDescription;
    architectures = [ "amd64" ];
    confinement = "strict";
    apps.hello.command = "${hello}/bin/hello";
  };
}
```

`nix-build` this expression and install it with `snap install ./result --dangerous`. `hello` will now be the Snapcraft version of the package.

## Build a Graphical Snap {#ssec-pkgs-snapTools-build-a-snap-firefox}

Graphical programs require many more integrations with the host. This example uses Firefox as an example because it is one of the most complicated programs we could package.

``` {#ex-snapTools-buildSnap-firefox .nix}
let
  inherit (import <nixpkgs> { }) snapTools firefox;
in snapTools.makeSnap {
  meta = {
    name = "nix-example-firefox";
    summary = firefox.meta.description;
    architectures = [ "amd64" ];
    apps.nix-example-firefox = {
      command = "${firefox}/bin/firefox";
      plugs = [
        "pulseaudio"
        "camera"
        "browser-support"
        "avahi-observe"
        "cups-control"
        "desktop"
        "desktop-legacy"
        "gsettings"
        "home"
        "network"
        "mount-observe"
        "removable-media"
        "x11"
      ];
    };
    confinement = "strict";
  };
}
```

`nix-build` this expression and install it with `snap install ./result --dangerous`. `nix-example-firefox` will now be the Snapcraft version of the Firefox package.

The specific meaning behind plugs can be looked up in the [Snapcraft interface documentation](https://docs.snapcraft.io/supported-interfaces).
