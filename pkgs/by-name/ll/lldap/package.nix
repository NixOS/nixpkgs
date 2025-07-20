{
  binaryen,
  fetchFromGitHub,
  lib,
  lldap,
  nixosTests,
  rustPlatform,
  rustc,
  wasm-bindgen-cli_0_2_95,
  wasm-pack,
  which,
}:

let

  commonDerivationAttrs = rec {
    pname = "lldap";
    version = "0.6.1";

    src = fetchFromGitHub {
      owner = "lldap";
      repo = "lldap";
      rev = "v${version}";
      hash = "sha256-iQ+Vv9kx/pWHoa/WZChBK+FD2r1avzWWz57bnnzRjUg=";
    };

    cargoHash = "sha256-qXYgr9uRswuo9hwVROUX9KUKpkzR0VEcXImbdyOgxsY=";

  };

  frontend = rustPlatform.buildRustPackage (
    commonDerivationAttrs
    // {
      pname = commonDerivationAttrs.pname + "-frontend";

      nativeBuildInputs = [
        wasm-pack
        wasm-bindgen-cli_0_2_95
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
