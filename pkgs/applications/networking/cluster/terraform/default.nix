{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, coreutils
, runCommand
, runtimeShell
, writeText
, terraform-providers
, fetchpatch
}:

let
  generic = { version, sha256, vendorSha256 ? null, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "version" "sha256" "vendorSha256" ];
    in
    buildGoModule ({
      name = "terraform-${version}";

      inherit vendorSha256;

      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "terraform";
        rev = "v${version}";
        inherit sha256;
      };

      postConfigure = ''
        # speakeasy hardcodes /bin/stty https://github.com/bgentry/speakeasy/issues/22
        substituteInPlace vendor/github.com/bgentry/speakeasy/speakeasy_unix.go \
          --replace "/bin/stty" "${coreutils}/bin/stty"
      '';

      postInstall = ''
        # remove all plugins, they are part of the main binary now
        for i in $out/bin/*; do
          if [[ $(basename $i) != terraform ]]; then
            rm "$i"
          fi
        done
      '';

      preCheck = ''
        export HOME=$TMPDIR
        export TF_SKIP_REMOTE_TESTS=1
      '';

      subPackages = [ "." ];

      meta = with lib; {
        description =
          "Tool for building, changing, and versioning infrastructure";
        homepage = "https://www.terraform.io/";
        changelog = "https://github.com/hashicorp/terraform/blob/v${version}/CHANGELOG.md";
        license = licenses.mpl20;
        maintainers = with maintainers; [
          Chili-Man
          babariviere
          kalbasit
          marsam
          timstott
          zimbatm
        ];
      };
    } // attrs');

  pluggable = terraform:
    let
      withPlugins = plugins:
        let
          actualPlugins = plugins terraform.plugins;

          # Make providers available in Terraform 0.13 and 0.12 search paths.
          pluginDir = lib.concatMapStrings
            (pl:
              let
                inherit (pl) version GOOS GOARCH;

                pname = pl.pname or (throw "${pl.name} is missing a pname attribute");

                # This is just the name, without the terraform-provider- prefix
                plugin_name = lib.removePrefix "terraform-provider-" pname;

                slug = pl.passthru.provider-source-address or "registry.terraform.io/nixpkgs/${plugin_name}";

                shim = writeText "shim" ''
                  #!${runtimeShell}
                  exec ${pl}/bin/${pname}_v${version} "$@"
                '';
              in
              ''
                TF_0_13_PROVIDER_PATH=$out/plugins/${slug}/${version}/${GOOS}_${GOARCH}/${pname}_v${version}
                mkdir -p "$(dirname $TF_0_13_PROVIDER_PATH)"

                cp ${shim} "$TF_0_13_PROVIDER_PATH"
                chmod +x "$TF_0_13_PROVIDER_PATH"

                TF_0_12_PROVIDER_PATH=$out/plugins/${pname}_v${version}

                cp ${shim} "$TF_0_12_PROVIDER_PATH"
                chmod +x "$TF_0_12_PROVIDER_PATH"
              ''
            )
            actualPlugins;

          # Wrap PATH of plugins propagatedBuildInputs, plugins may have runtime dependencies on external binaries
          wrapperInputs = lib.unique (lib.flatten
            (lib.catAttrs "propagatedBuildInputs"
              (builtins.filter (x: x != null) actualPlugins)));

          passthru = {
            withPlugins = newplugins:
              withPlugins (x: newplugins x ++ actualPlugins);
            full = withPlugins lib.attrValues;

            # Ouch
            overrideDerivation = f:
              (pluggable (terraform.overrideDerivation f)).withPlugins plugins;
            overrideAttrs = f:
              (pluggable (terraform.overrideAttrs f)).withPlugins plugins;
            override = x:
              (pluggable (terraform.override x)).withPlugins plugins;
          };
          # Don't bother wrapping unless we actually have plugins, since the wrapper will stop automatic downloading
          # of plugins, which might be counterintuitive if someone just wants a vanilla Terraform.
        in
        if actualPlugins == [ ] then
          terraform.overrideAttrs
            (orig: { passthru = orig.passthru // passthru; })
        else
          lib.appendToName "with-plugins" (stdenv.mkDerivation {
            inherit (terraform) name meta;
            nativeBuildInputs = [ makeWrapper ];

            buildCommand = pluginDir + ''
              mkdir -p $out/bin/
              makeWrapper "${terraform}/bin/terraform" "$out/bin/terraform" \
                --set NIX_TERRAFORM_PLUGIN_DIR $out/plugins \
                --prefix PATH : "${lib.makeBinPath wrapperInputs}"
            '';

            inherit passthru;
          });
    in
    withPlugins (_: [ ]);

  plugins = removeAttrs terraform-providers [
    "override"
    "overrideDerivation"
    "recurseForDerivations"
  ];
in
rec {
  # Constructor for other terraform versions
  mkTerraform = attrs: pluggable (generic attrs);

  terraform_0_12 = mkTerraform {
    version = "0.12.31";
    sha256 = "03p698xdbk5gj0f9v8v1fpd74zng3948dyy4f2hv7zgks9hid7fg";
    patches = [
      ./provider-path.patch
      (fetchpatch {
        name = "fix-mac-mojave-crashes.patch";
        url = "https://github.com/hashicorp/terraform/commit/cd65b28da051174a13ac76e54b7bb95d3051255c.patch";
        sha256 = "1k70kk4hli72x8gza6fy3vpckdm3sf881w61fmssrah3hgmfmbrs";
      })
    ];
    passthru = { inherit plugins; };
  };

  terraform_0_13 = mkTerraform {
    version = "0.13.7";
    sha256 = "1cahnmp66dk21g7ga6454yfhaqrxff7hpwpdgc87cswyq823fgjn";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  };

  terraform_0_14 = mkTerraform {
    version = "0.14.11";
    sha256 = "1yi1jj3n61g1kn8klw6l78shd23q79llb7qqwigqrx3ki2mp279j";
    vendorSha256 = "1d93aqkjdrvabkvix6h1qaxpjzv7w1wa7xa44czdnjs2lapx4smm";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  };

  terraform_0_15 = mkTerraform {
    version = "0.15.5";
    sha256 = "18f4a6l24s3cym7gk40agxikd90i56q84wziskw1spy9rgv2yx6d";
    vendorSha256 = "12hrpxay6k3kz89ihyhl91c4lw4wp821ppa245w9977fq09fhnx0";
    patches = [ ./provider-path-0_15.patch ];
    passthru = { inherit plugins; };
  };

  terraform_1_0 = mkTerraform {
    version = "1.0.1";
    sha256 = "0sy33wf2wjhybr5smmyla7ci61w8irk0nrv3vv7h87yli1dd9yj0";
    vendorSha256 = "0ai7h85f0xdlh7q04l4hb9m5wajyqbylhvpjanlhkzvc60silhmx";
    patches = [ ./provider-path-0_15.patch ];
    passthru = { inherit plugins; };
  };

  # Tests that the plugins are being used. Terraform looks at the specific
  # file pattern and if the plugin is not found it will try to download it
  # from the Internet. With sandboxing enable this test will fail if that is
  # the case.
  terraform_plugins_test =
    let
      mainTf = writeText "main.tf" ''
        resource "random_id" "test" {}
      '';
      terraform = terraform_1_0.withPlugins (p: [ p.random ]);
      test =
        runCommand "terraform-plugin-test" { buildInputs = [ terraform ]; } ''
          set -e
          # make it fail outside of sandbox
          export HTTP_PROXY=http://127.0.0.1:0 HTTPS_PROXY=https://127.0.0.1:0
          cp ${mainTf} main.tf
          terraform init
          touch $out
        '';
    in
    test;

}
