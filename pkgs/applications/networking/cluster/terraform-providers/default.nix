{ lib
, buildGoPackage
, fetchFromGitHub
, callPackage
}:
let
  list = import ./data.nix;

  toDrv = data:
    buildGoPackage rec {
      inherit (data) owner repo rev version sha256;
      name = "${repo}-${version}";
      goPackagePath = "github.com/${owner}/${repo}";
      subPackages = [ "." ];
      src = fetchFromGitHub {
        inherit owner repo rev sha256;
      };
      # Terraform allow checking the provider versions, but this breaks
      # if the versions are not provided via file paths.
      postBuild = "mv go/bin/${repo}{,_v${version}}";
    };

  # Google is now using the vendored go modules, which works a bit differently
  # and is not 100% compatible with the pre-modules vendored folders.
  #
  # Instead of switching to goModules which requires a goModSha256, patch the
  # goPackage derivation so it can install the top-level.
  patchGoModVendor = drv:
    drv.overrideAttrs (attrs: {
      buildFlags = "-mod=vendor";

      # override configurePhase to not move the source into GOPATH
      configurePhase = ''
        export GOPATH=$NIX_BUILD_TOP/go:$GOPATH
        export GOCACHE=$TMPDIR/go-cache
        export GO111MODULE=on
      '';

      # just build and install into $GOPATH/bin
      buildPhase = ''
        go install -mod=vendor -v -p 16 .
      '';

      # don't run the tests, they are broken in this setup
      doCheck = false;
    });

  # These providers are managed with the ./update-all script
  automated-providers = lib.mapAttrs (_: toDrv) list;

  # These are the providers that don't fall in line with the default model
  special-providers = {
    # Override the google providers
    google = patchGoModVendor automated-providers.google;
    google-beta = patchGoModVendor automated-providers.google-beta;

    elasticsearch = callPackage ./elasticsearch {};
    gandi = callPackage ./gandi {};
    ibm = callPackage ./ibm {};
    libvirt = callPackage ./libvirt {};
    lxd = callPackage ./lxd {};
    ansible = callPackage ./ansible {};
  };
in
  automated-providers // special-providers
