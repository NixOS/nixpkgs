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
}:

let

  commonDerivationAttrs = {
    pname = "lldap";
    version = "unstable-2025-07-16";

    src = fetchFromGitHub {
      owner = "lldap";
      repo = "lldap";
      rev = "78337bce722c3573d9fc6eafe345a3dbce4b9119";
      hash = "sha256-/djLboAQwK/KQ0u9vzoOdDHwh/BQSvMa8lQkABn10Cw=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-/dyrtX2FUHSGkJ6AkCM81iPqI03IWA0tecR4KHSx8gA=";

  };

  frontend = rustPlatform.buildRustPackage (
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
        HOME=`pwd` ./app/build.sh
      '';

      installPhase = ''
        mkdir -p $out
        cp -R app/{index.html,pkg,static} $out/
      '';

      doCheck = false;
    }
  );

in
rustPlatform.buildRustPackage (
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
        --set LLDAP_ASSETS_PATH ${frontend}
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
