{ lib
, buildGoModule
, fetchFromGitHub
, callPackage
, config

, cdrtools # libvirt
}:
let
  # Our generic constructor to build new providers.
  #
  # Is designed to combine with the terraform.withPlugins implementation.
  mkProvider = lib.makeOverridable
    ({ owner
     , repo
     , rev
     , version
     , sha256
     , vendorSha256 ? throw "vendorSha256 missing: please use `buildGoModule`" /* added 2022/01 */
     , deleteVendor ? false
     , proxyVendor ? false
     , # Looks like "registry.terraform.io/vancluever/acme"
       provider-source-address
     }@attrs:
      buildGoModule {
        pname = repo;
        inherit vendorSha256 version deleteVendor proxyVendor;
        subPackages = [ "." ];
        doCheck = false;
        # https://github.com/hashicorp/terraform-provider-scaffolding/blob/a8ac8375a7082befe55b71c8cbb048493dd220c2/.goreleaser.yml
        # goreleaser (used for builds distributed via terraform registry) requires that CGO is disabled
        CGO_ENABLED = 0;
        ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${rev}" ];
        src = fetchFromGitHub {
          inherit owner repo rev sha256;
        };

        # Move the provider to libexec
        postInstall = ''
          dir=$out/libexec/terraform-providers/${provider-source-address}/${version}/''${GOOS}_''${GOARCH}
          mkdir -p "$dir"
          mv $out/bin/* "$dir/terraform-provider-$(basename ${provider-source-address})_${version}"
          rmdir $out/bin
        '';

        # Keep the attributes around for later consumption
        passthru = attrs;
      });

  list = lib.importJSON ./providers.json;

  # These providers are managed with the ./update-all script
  automated-providers = lib.mapAttrs (_: attrs: mkProvider attrs) list;

  # These are the providers that don't fall in line with the default model
  special-providers =
    {
      # Packages that don't fit the default model

      # mkisofs needed to create ISOs holding cloud-init data,
      # and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
      libvirt = automated-providers.libvirt.overrideAttrs (_: { propagatedBuildInputs = [ cdrtools ]; });
    };

  # Put all the providers we not longer support in this list.
  removed-providers =
    let
      archived = date: throw "the provider has been archived by upstream on ${date}";
      removed = date: throw "removed from nixpkgs on ${date}";
    in
    lib.optionalAttrs (config.allowAliases or false) {
      arukas = archived "2022/01";
      bitbucket = archived "2022/01";
      chef = archived "2022/01";
      cherryservers = archived "2022/01";
      clc = archived "2022/01";
      cloudstack = removed "2022/01";
      cobbler = archived "2022/01";
      cohesity = archived "2022/01";
      dyn = archived "2022/01";
      genymotion = archived "2022/01";
      hedvig = archived "2022/01";
      ignition = archived "2022/01";
      incapsula = archived "2022/01";
      influxdb = archived "2022/01";
      jdcloud = archived "2022/01";
      kubernetes-alpha = throw "This has been merged as beta into the kubernetes provider. See https://www.hashicorp.com/blog/beta-support-for-crds-in-the-terraform-provider-for-kubernetes for details";
      librato = archived "2022/01";
      logentries = archived "2022/01";
      metalcloud = archived "2022/01";
      mysql = archived "2022/01";
      nixos = archived "2022/01";
      oneandone = archived "2022/01";
      packet = archived "2022/01";
      profitbricks = archived "2022/01";
      pureport = archived "2022/01";
      rancher = archived "2022/01";
      rightscale = archived "2022/01";
      runscope = archived "2022/01";
      segment = removed "2022/01";
      softlayer = archived "2022/01";
      telefonicaopencloud = archived "2022/01";
      teleport = removed "2022/01";
      terraform = archived "2022/01";
      ultradns = archived "2022/01";
      vthunder = throw "provider was renamed to thunder on 2022/01";
    };
in
automated-providers // special-providers // removed-providers // { inherit mkProvider; }
