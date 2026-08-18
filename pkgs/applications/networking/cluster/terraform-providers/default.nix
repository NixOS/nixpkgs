{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchFromGitLab,
  callPackage,
  config,
  writeShellScript,

  cdrtools, # libvirt
}:
let
  # Our generic constructor to build new providers.
  #
  # Is designed to combine with the terraform.withPlugins implementation.
  mkProvider = lib.makeOverridable (
    {
      owner,
      repo,
      rev,
      spdx ? "UNSET",
      version ? lib.removePrefix "v" rev,
      hash,
      vendorHash,
      deleteVendor ? false,
      proxyVendor ? false,
      mkProviderFetcher ? fetchFromGitHub,
      mkProviderGoModule ? buildGoModule,
      # "https://registry.terraform.io/providers/vancluever/acme"
      homepage ? "",
      # "registry.terraform.io/vancluever/acme"
      provider-source-address ?
        lib.replaceStrings [ "https://registry" ".io/providers" ] [ "registry" ".io" ]
          homepage,
      ...
    }@attrs:
    assert lib.stringLength provider-source-address > 0;
    mkProviderGoModule {
      pname = repo;
      inherit
        vendorHash
        version
        deleteVendor
        proxyVendor
        ;
      subPackages = [ "." ];
      doCheck = false;
      # https://github.com/hashicorp/terraform-provider-scaffolding/blob/a8ac8375a7082befe55b71c8cbb048493dd220c2/.goreleaser.yml
      # goreleaser (used for builds distributed via terraform registry) requires that CGO is disabled
      env.CGO_ENABLED = 0;
      ldflags = [
        "-s"
        "-w"
        "-X main.version=${version}"
        "-X main.commit=${rev}"
      ];
      src = mkProviderFetcher {
        name = "source-${rev}";
        inherit
          owner
          repo
          rev
          hash
          ;
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
          ./pkgs/applications/networking/cluster/terraform-providers/update-provider "${
            lib.replaceStrings [ "registry.terraform.io/" "/" ] [ "" "_" ] provider-source-address
          }"
        '';
      };
    }
  );

  list = lib.importJSON ./providers.json;

  # These providers are managed with the ./update-all script
  automated-providers = lib.mapAttrs (_: attrs: mkProvider attrs) list;

  # These are the providers that don't fall in line with the default model
  special-providers = {
    # github api seems to be broken, doesn't just fail to recognize the license, it's ignored entirely.
    checkly_checkly = automated-providers.checkly_checkly.override { spdx = "MIT"; };
    gitlabhq_gitlab = automated-providers.gitlabhq_gitlab.override {
      mkProviderFetcher = fetchFromGitLab;
      owner = "gitlab-org";
    };
    # mkisofs needed to create ISOs holding cloud-init data and wrapped to terraform via deecb4c1aab780047d79978c636eeb879dd68630
    dmacvicar_libvirt = automated-providers.dmacvicar_libvirt.overrideAttrs (_: {
      propagatedBuildInputs = [ cdrtools ];
    });
    aminueza_minio = automated-providers.aminueza_minio.override { spdx = "AGPL-3.0-only"; };
    # proxyVendor is necessary because enabling CGO causes `go mod vendor` to include
    # platform-specific files leading to vendorHash varying across platforms.
    "1password_onepassword" =
      (automated-providers."1password_onepassword".override { proxyVendor = true; }).overrideAttrs
        (finalAttrs: {
          env = finalAttrs.env // {
            CGO_ENABLED = "1";
          };
        });
  };

  # Put all the providers we not longer support in this list.
  removed-providers =
    let
      archived =
        name: date: throw "the ${name} terraform provider has been archived by upstream on ${date}";
      removed = name: date: throw "the ${name} terraform provider removed from nixpkgs on ${date}";
    in
    lib.optionalAttrs config.allowAliases {
      ccloud = removed "ccloud" "2025/11. Try sap-cloud-infrastructure_sci instead.";
      sapcc_ccloud = removed "sapcc_ccloud" "2025/11. Try sap-cloud-infrastructure_sci instead.";
      argocd = removed "argocd" "2025/12. Try argoproj-labs_argocd instead.";
      oboukili_argocd = removed "oboukili_argocd" "2025/12. Try argoproj-labs_argocd instead.";
    };

  # excluding aliases, used by terraform-full
  actualProviders = automated-providers // special-providers;
in
actualProviders // removed-providers // { inherit actualProviders mkProvider; }
