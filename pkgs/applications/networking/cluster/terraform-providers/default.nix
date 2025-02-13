{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchFromGitLab
, callPackage
, config
, writeShellScript

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
     , spdx ? "UNSET"
     , version ? lib.removePrefix "v" rev
     , hash
     , vendorHash
     , deleteVendor ? false
     , proxyVendor ? false
     , mkProviderFetcher ? fetchFromGitHub
     , mkProviderGoModule ? buildGoModule
       # "https://registry.terraform.io/providers/vancluever/acme"
     , homepage ? ""
       # "registry.terraform.io/vancluever/acme"
     , provider-source-address ? lib.replaceStrings [ "https://registry" ".io/providers" ] [ "registry" ".io" ] homepage
     , ...
     }@attrs:
      assert lib.stringLength provider-source-address > 0;
      mkProviderGoModule {
        pname = repo;
        inherit vendorHash version deleteVendor proxyVendor;
        subPackages = [ "." ];
        doCheck = false;
        # https://github.com/hashicorp/terraform-provider-scaffolding/blob/a8ac8375a7082befe55b71c8cbb048493dd220c2/.goreleaser.yml
        # goreleaser (used for builds distributed via terraform registry) requires that CGO is disabled
        env.CGO_ENABLED = 0;
        ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${rev}" ];
        src = mkProviderFetcher {
          name = "source-${rev}";
          inherit owner repo rev hash;
        };

        meta = {
          inherit homepage;
          license = lib.getLicenseFromSpdxId spdx;
        };

        # Move the provider to libexec
        postInstall = ''
          dir=$out/libexec/terraform-providers/${provider-source-address}/${version}/''${GOOS}_''${GOARCH}
          mkdir -p "$dir"
          mv $out/bin/* "$dir/terraform-provider-$(basename ${provider-source-address})_${version}"
          rmdir $out/bin
        '';

        # Keep the attributes around for later consumption
        passthru = attrs // {
          inherit provider-source-address;
          updateScript = writeShellScript "update" ''
            provider="$(basename ${provider-source-address})"
            ./pkgs/applications/networking/cluster/terraform-providers/update-provider "$provider"
          '';
        };
      });

  list = lib.importJSON ./providers.json;

  # These providers are managed with the ./update-all script
  automated-providers = lib.mapAttrs (_: attrs: mkProvider attrs) list;

  # These are the providers that don't fall in line with the default model
  special-providers =
    {
      # github api seems to be broken, doesn't just fail to recognize the license, it's ignored entirely.
      checkly = automated-providers.checkly.override { spdx = "MIT"; };
      gitlab = automated-providers.gitlab.override { mkProviderFetcher = fetchFromGitLab; owner = "gitlab-org"; };
      # actions update always fails but can't reproduce the failure.
      heroku = automated-providers.heroku.override { spdx = "MPL-2.0"; };
      # mkisofs needed to create ISOs holding cloud-init data and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
      libvirt = automated-providers.libvirt.overrideAttrs (_: { propagatedBuildInputs = [ cdrtools ]; });
      minio = automated-providers.minio.override { spdx = "AGPL-3.0-only"; };
    };

  # Put all the providers we not longer support in this list.
  removed-providers =
    let
      archived = name: date: throw "the ${name} terraform provider has been archived by upstream on ${date}";
      removed = name: date: throw "the ${name} terraform provider removed from nixpkgs on ${date}";
    in
    lib.optionalAttrs config.allowAliases {
      fly = archived "fly" "2023/10";
    };

  # excluding aliases, used by terraform-full
  actualProviders = automated-providers // special-providers;
in
actualProviders // removed-providers // { inherit actualProviders mkProvider; }
