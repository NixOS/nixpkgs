{ lib
, buildGoPackage
, fetchFromGitHub
, callPackage
, runtimeShell
}:
let
  list = lib.importJSON ./providers.json;

  toDrv = name: data:
    buildGoPackage {
      pname = data.repo;
      version = data.version;
      goPackagePath = "github.com/${data.owner}/${data.repo}";
      subPackages = [ "." ];
      src = fetchFromGitHub {
        inherit (data) owner repo rev sha256;
      };
      # Terraform allow checking the provider versions, but this breaks
      # if the versions are not provided via file paths.
      postBuild = "mv $NIX_BUILD_TOP/go/bin/${data.repo}{,_v${data.version}}";
      passthru = data;
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

        runHook postBuild
      '';

      # don't run the tests, they are broken in this setup
      doCheck = false;
    });

  # These providers are managed with the ./update-all script
  automated-providers = lib.mapAttrs (toDrv) list;

  # These are the providers that don't fall in line with the default model
  special-providers = {
    # Override providers that use Go modules + vendor/ folder
    google = patchGoModVendor automated-providers.google;
    google-beta = patchGoModVendor automated-providers.google-beta;
    ibm = patchGoModVendor automated-providers.ibm;

    acme = automated-providers.acme.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-acme getstackhead/terraform-provider-acme
        substituteInPlace main.go --replace terraform-providers/terraform-provider-acme getstackhead/terraform-provider-acme
      '';
    });

    # providers that were moved to the `hashicorp` organization,
    # but haven't updated their references yet:

    # https://github.com/hashicorp/terraform-provider-archive/pull/67
    archive = automated-providers.archive.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-archive hashicorp/terraform-provider-archive
        substituteInPlace main.go --replace terraform-providers/terraform-provider-archive hashicorp/terraform-provider-archive
      '';
    });

    # https://github.com/hashicorp/terraform-provider-dns/pull/101
    dns = automated-providers.dns.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-dns hashicorp/terraform-provider-dns
        substituteInPlace main.go --replace terraform-providers/terraform-provider-dns hashicorp/terraform-provider-dns
      '';
    });

    # https://github.com/hashicorp/terraform-provider-external/pull/41
    external = automated-providers.external.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-external hashicorp/terraform-provider-external
        substituteInPlace main.go --replace terraform-providers/terraform-provider-external hashicorp/terraform-provider-external
      '';
    });

    # https://github.com/hashicorp/terraform-provider-helm/pull/522
    helm = automated-providers.helm.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-helm hashicorp/terraform-provider-helm
        substituteInPlace main.go --replace terraform-providers/terraform-provider-helm hashicorp/terraform-provider-helm
      '';
    });

    # https://github.com/hashicorp/terraform-provider-http/pull/40
    http = automated-providers.http.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-http hashicorp/terraform-provider-http
        substituteInPlace main.go --replace terraform-providers/terraform-provider-http hashicorp/terraform-provider-http
      '';
    });

    # https://github.com/hashicorp/terraform-provider-local/pull/40
    local = automated-providers.local.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-local hashicorp/terraform-provider-local
        substituteInPlace main.go --replace terraform-providers/terraform-provider-local hashicorp/terraform-provider-local
      '';
    });

    # https://github.com/hashicorp/terraform-provider-null/pull/43
    null = automated-providers.null.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-null hashicorp/terraform-provider-null
        substituteInPlace main.go --replace terraform-providers/terraform-provider-null hashicorp/terraform-provider-null
      '';
    });

    # https://github.com/hashicorp/terraform-provider-random/pull/107
    random = automated-providers.random.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-random hashicorp/terraform-provider-random
        substituteInPlace main.go --replace terraform-providers/terraform-provider-random hashicorp/terraform-provider-random
      '';
    });

    # https://github.com/hashicorp/terraform-provider-template/pull/79
    template = automated-providers.template.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-template hashicorp/terraform-provider-template
        substituteInPlace main.go --replace terraform-providers/terraform-provider-template hashicorp/terraform-provider-template
      '';
    });

    # https://github.com/hashicorp/terraform-provider-tls/pull/71
    tls = automated-providers.tls.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-tls hashicorp/terraform-provider-tls
        substituteInPlace main.go --replace terraform-providers/terraform-provider-tls hashicorp/terraform-provider-tls
      '';
    });

    # provider was moved to the `vultr` organization, but kept the old references:
    # https://github.com/vultr/terraform-provider-vultr/pull/67
    # this override should be removed as soon as new version (>1.4.1) is released.
    vultr = automated-providers.vultr.overrideAttrs (attrs: {
      prePatch = attrs.prePatch or "" + ''
        substituteInPlace go.mod --replace terraform-providers/terraform-provider-vultr vultr/terraform-provider-vultr
        substituteInPlace main.go --replace terraform-providers/terraform-provider-vultr vultr/terraform-provider-vultr
      '';
    });

    # Packages that don't fit the default model
    ansible = callPackage ./ansible {};
    cloudfoundry = callPackage ./cloudfoundry {};
    elasticsearch = callPackage ./elasticsearch {};
    gandi = callPackage ./gandi {};
    keycloak = callPackage ./keycloak {};
    libvirt = callPackage ./libvirt {};
    lxd = callPackage ./lxd {};
    shell = callPackage ./shell {};
    vpsadmin = callPackage ./vpsadmin {};
  };
in
  automated-providers // special-providers
