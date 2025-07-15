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
    version = "unstable-2025-08-13";

    src = fetchFromGitHub {
      owner = "ibizaman";
      repo = "lldap";
      rev = "220c25f1abdc0c62f8ef3a41f25a3f4044094318";
      hash = "sha256-hByibduVbG+6uB0oUcgc+UzyR5WLieaRJ+61q8DCca0=";
    };

    useFetchCargoVendor = true;
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
