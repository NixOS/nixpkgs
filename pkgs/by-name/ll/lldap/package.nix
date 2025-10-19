{
  binaryen,
  fetchFromGitHub,
  lib,
  lldap,
  makeWrapper,
  nixosTests,
  rustPlatform,
  rustc,
  wasm-bindgen-cli_0_2_100,
  wasm-pack,
  which,
  runCommand,
  cacert,
  curl,
  staticAssetsHash ? "sha256-xVbHD9s3ofbtHCDvjYwmsWXDEJ9z9vRxQDRR6pW6rt8=",
}:

let
  version = "0.6.2";

  commonDerivationAttrs = {
    pname = "lldap";
    inherit version;

    src = fetchFromGitHub {
      owner = "lldap";
      repo = "lldap";
      rev = "v${version}";
      hash = "sha256-UBQWOrHika8X24tYdFfY8ETPh9zvI7/HV5j4aK8Uq+Y=";
    };

    cargoHash = "sha256-SO7+HiiXNB/KF3fjzSMeiTPjRQq/unEfsnplx4kZv9c=";
  };

  staticAssets =
    src:
    runCommand "${commonDerivationAttrs.pname}-static-assets"
      {
        outputHash = staticAssetsHash;
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";

        inherit src;

        nativeBuildInputs = [
          curl
        ];

        env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      }
      ''
        mkdir $out
        mkdir $out/fonts
        for file in $(cat ${src}/app/static/libraries.txt); do
          curl $file --location --remote-name --output-dir $out
        done
        for file in $(cat ${src}/app/static/fonts/fonts.txt); do
          curl $file --location --remote-name --output-dir $out/fonts
        done
      '';

  frontend = rustPlatform.buildRustPackage (
    finalAttrs:
    commonDerivationAttrs
    // {
      pname = commonDerivationAttrs.pname + "-frontend";

      nativeBuildInputs = [
        wasm-pack
        wasm-bindgen-cli_0_2_100
        binaryen
        which
        rustc
        rustc.llvmPackages.lld
      ];

      buildPhase = ''
        runHook preBuild

        HOME=`pwd` ./app/build.sh

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -R app/{pkg,static} $out/
        cp app/index_local.html $out/index.html
        cp -R ${staticAssets finalAttrs.src}/* $out/static
        rm $out/static/libraries.txt $out/static/fonts/fonts.txt

        runHook postInstall
      '';

      doCheck = false;
    }
  );

in
rustPlatform.buildRustPackage (
  finalAttrs:
  commonDerivationAttrs
  // {
    cargoBuildFlags = [
      "-p"
      "lldap"
      "-p"
      "lldap_migration_tool"
      "-p"
      "lldap_set_password"
    ];

    nativeBuildInputs = [ makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/lldap \
        --set LLDAP_ASSETS_PATH ${finalAttrs.finalPackage.frontend}
    '';

    passthru = {
      inherit frontend;
      tests = {
        inherit (nixosTests) lldap;
      };
    };

    meta = with lib; {
      description = "Lightweight authentication server that provides an opinionated, simplified LDAP interface for authentication";
      homepage = "https://github.com/lldap/lldap";
      changelog = "https://github.com/lldap/lldap/blob/v${lldap.version}/CHANGELOG.md";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [
        bendlas
        ibizaman
      ];
      mainProgram = "lldap";
    };
  }

)
