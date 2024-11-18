{
  binaryen,
  fetchFromGitHub,
  lib,
  lldap,
  nixosTests,
  rustPlatform,
  rustc,
  wasm-bindgen-cli,
  wasm-pack,
  which,
}:

let

  commonDerivationAttrs = {
    pname = "lldap";
    version = "0.5.1-unstable-2024-10-30";

    src = fetchFromGitHub {
      owner = "lldap";
      repo = "lldap";
      rev = "143eb70bee92e8225028ea00b69735a28e8c088d";
      hash = "sha256-6XGKz/OKHd80yX9a4rlvc9RZjBB6ao+jiO5Vlcc0ohE=";
    };

    # `Cargo.lock` has git dependencies, meaning can't use `cargoHash`
    useFetchCargoVendor = true;
    cargoHash = "sha256-zsOQSHVgJyv3VlKiufayQEPKEVWljgL2px9di8LK8bk=";

  };

  frontend = rustPlatform.buildRustPackage (
    commonDerivationAttrs
    // {
      pname = commonDerivationAttrs.pname + "-frontend";

      nativeBuildInputs = [
        wasm-pack
        wasm-bindgen-cli
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

    patches = [
      ./0001-parameterize-frontend-location.patch
    ];

    postPatch = ''
      substituteInPlace server/src/infra/tcp_server.rs --subst-var-by frontend '${frontend}'
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
      maintainers = with maintainers; [ bendlas ];
      mainProgram = "lldap";
    };
  }
)
