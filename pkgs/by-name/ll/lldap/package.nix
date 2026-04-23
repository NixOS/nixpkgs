{
  binaryen,
  fetchFromGitHub,
  lib,
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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lldap";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "lldap";
    repo = "lldap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UBQWOrHika8X24tYdFfY8ETPh9zvI7/HV5j4aK8Uq+Y=";
  };

  cargoHash = "sha256-SO7+HiiXNB/KF3fjzSMeiTPjRQq/unEfsnplx4kZv9c=";
  ## workaround for overrideAttrs on buildRustPackage
  ## see https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "${finalAttrs.pname}-cargo-deps";
    inherit (finalAttrs) src patches;
    hash = finalAttrs.cargoHash;
  };

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

    frontend = rustPlatform.buildRustPackage {
      inherit (finalAttrs)
        version
        src
        cargoDeps
        patches
        ;
      pname = finalAttrs.pname + "-frontend";
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
        cp -R ${finalAttrs.finalPackage.staticAssets}/* $out/static
        rm $out/static/libraries.txt $out/static/fonts/fonts.txt
        runHook postInstall
      '';
      doCheck = false;
    };

    staticAssets =
      runCommand "${finalAttrs.pname}-static-assets"
        {
          outputHash = staticAssetsHash;
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
          inherit (finalAttrs) src;
          nativeBuildInputs = [
            curl
          ];
          env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        }
        ''
          mkdir $out
          mkdir $out/fonts
          for file in $(cat $src/app/static/libraries.txt); do
            curl $file --location --remote-name --output-dir $out
          done
          for file in $(cat $src/app/static/fonts/fonts.txt); do
            curl $file --location --remote-name --output-dir $out/fonts
          done
        '';

    tests = {
      inherit (nixosTests) lldap;
    };

  };

  meta = {
    description = "Lightweight authentication server that provides an opinionated, simplified LDAP interface for authentication";
    homepage = "https://github.com/lldap/lldap";
    changelog = "https://github.com/lldap/lldap/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bendlas
      ibizaman
    ];
    mainProgram = "lldap";
  };
})
