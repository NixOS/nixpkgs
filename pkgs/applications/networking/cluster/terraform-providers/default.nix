{ lib
, buildGoModule
, fetchFromGitHub
, callPackage
, config

, cdrtools # libvirt
}:
let
  list = lib.importJSON ./providers.json;

  buildWithGoModule = data:
    buildGoModule {
      pname = data.repo;
      inherit (data) vendorSha256 version;
      subPackages = [ "." ];
      doCheck = false;
      # https://github.com/hashicorp/terraform-provider-scaffolding/blob/a8ac8375a7082befe55b71c8cbb048493dd220c2/.goreleaser.yml
      # goreleaser (used for builds distributed via terraform registry) requires that CGO is disabled
      CGO_ENABLED = 0;
      ldflags = [ "-s" "-w" "-X main.version=${data.version}" "-X main.commit=${data.rev}" ];
      src = fetchFromGitHub {
        inherit (data) owner repo rev sha256;
      };
      deleteVendor = data.deleteVendor or false;
      proxyVendor = data.proxyVendor or false;

      # Terraform allow checking the provider versions, but this breaks
      # if the versions are not provided via file paths.
      postBuild = "mv $NIX_BUILD_TOP/go/bin/${data.repo}{,_v${data.version}}";
      passthru = data;
    };

  # Our generic constructor to build new providers
  mkProvider = attrs:
    (if (lib.hasAttr "vendorSha256" attrs) then buildWithGoModule else throw /* added 2022/01 */ "vendorSha256 missing: please use `buildGoModule`")
      attrs;

  # These providers are managed with the ./update-all script
  automated-providers = lib.mapAttrs (_: attrs: mkProvider attrs) list;

  # These are the providers that don't fall in line with the default model
  special-providers = let archived = throw "the provider has been archived by upstream"; in {
    # Packages that don't fit the default model
    gandi = callPackage ./gandi { };
    # mkisofs needed to create ISOs holding cloud-init data,
    # and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
    libvirt = automated-providers.libvirt.overrideAttrs (_: { propagatedBuildInputs = [ cdrtools ]; });
    teleport = callPackage ./teleport { };
    vpsadmin = callPackage ./vpsadmin { };
  } // (lib.optionalAttrs (config.allowAliases or false) {
    arukas = archived; # added 2022/01
    bitbucket = archived; # added 2022/01
    chef = archived; # added 2022/01
    cherryservers = archived; # added 2022/01
    clc = archived; # added 2022/01
    cloudstack = throw "removed from nixpkgs"; # added 2022/01
    cobbler = archived; # added 2022/01
    cohesity = archived; # added 2022/01
    dyn = archived; # added 2022/01
    genymotion = archived; # added 2022/01
    hedvig = archived; # added 2022/01
    ignition = archived; # added 2022/01
    incapsula = archived; # added 2022/01
    influxdb = archived; # added 2022/01
    jdcloud = archived; # added 2022/01
    kubernetes-alpha = throw "This has been merged as beta into the kubernetes provider. See https://www.hashicorp.com/blog/beta-support-for-crds-in-the-terraform-provider-for-kubernetes for details";
    librato = archived; # added 2022/01
    logentries = archived; # added 2022/01
    metalcloud = archived; # added 2022/01
    mysql = archived; # added 2022/01
    nixos = archived; # added 2022/01
    oneandone = archived; # added 2022/01
    packet = archived; # added 2022/01
    profitbricks = archived; # added 2022/01
    pureport = archived; # added 2022/01
    rancher = archived; # added 2022/01
    rightscale = archived; # added 2022/01
    runscope = archived; # added 2022/01
    segment = throw "removed from nixpkgs"; # added 2022/01
    softlayer = archived; # added 2022/01
    telefonicaopencloud = archived; # added 2022/01
    terraform = archived; # added 2022/01
    ultradns = archived; # added 2022/01
    vthunder = throw "provider was renamed to thunder"; # added 2022/01
  });
in
automated-providers // special-providers // { inherit mkProvider; }
