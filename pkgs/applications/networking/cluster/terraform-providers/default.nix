{ lib
, stdenv
, buildGoModule
, buildGo117Module
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
     , vendorSha256
     , deleteVendor ? false
     , proxyVendor ? false
     , mkProviderGoModule ? buildGoModule
     , # Looks like "registry.terraform.io/vancluever/acme"
       provider-source-address
     }@attrs:
      mkProviderGoModule {
        pname = repo;
        inherit vendorSha256 version deleteVendor proxyVendor;
        subPackages = [ "." ];
        doCheck = false;
        # https://github.com/hashicorp/terraform-provider-scaffolding/blob/a8ac8375a7082befe55b71c8cbb048493dd220c2/.goreleaser.yml
        # goreleaser (used for builds distributed via terraform registry) requires that CGO is disabled
        CGO_ENABLED = 0;
        ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${rev}" ];
        src = fetchFromGitHub {
          name = "source-${rev}";
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
      # mkisofs needed to create ISOs holding cloud-init data and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
      libvirt = automated-providers.libvirt.overrideAttrs (_: { propagatedBuildInputs = [ cdrtools ]; });
      # fails to build on x86_64-darwin with 1.18
      lxd = automated-providers.lxd.override { mkProviderGoModule = buildGo117Module; };
      # fails to build on x86_64-darwin with 1.18
      netlify = automated-providers.netlify.override { mkProviderGoModule = buildGo117Module; };
      # fails to build on x86_64-darwin with 1.18
      pass = automated-providers.pass.override { mkProviderGoModule = buildGo117Module; };
      # fails to build on x86_64-darwin with 1.18
      skytap = automated-providers.skytap.override { mkProviderGoModule = buildGo117Module; };
      # fails to build on x86_64-{darwin,linux} with 1.18
      tencentcloud = automated-providers.tencentcloud.override { mkProviderGoModule = buildGo117Module; };
    };

  # Put all the providers we not longer support in this list.
  removed-providers =
    let
      archived = name: date: throw "the ${name} terraform provider has been archived by upstream on ${date}";
      removed = name: date: throw "the ${name} terraform provider removed from nixpkgs on ${date}";
    in
    lib.optionalAttrs config.allowAliases {
      b2 = removed "b2" "2022/06";
      opc = archived "opc" "2022/05";
      oraclepaas = archived "oraclepaas" "2022/05";
      template = archived "template" "2022/05";
    };

  # excluding aliases, used by terraform-full
  actualProviders = automated-providers // special-providers;
in
actualProviders // removed-providers // { inherit actualProviders mkProvider; }
