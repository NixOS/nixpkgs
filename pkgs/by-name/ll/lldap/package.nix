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
