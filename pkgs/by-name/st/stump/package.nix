{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  rustPlatform,
  nodejs,
  pdfium,
  openssl,
  dbus,
  glib,
  gtk3,
  webkitgtk_4_1,
  cacert,
  pkg-config,
  makeWrapper,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stump";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "stumpapp";
    repo = "stump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-izz5ijAvSuqCjSBQarVV+XtkTcSt2VYgYSIIvXqXnms=";
  };

  frontend = stdenv.mkDerivation (_: {
    pname = "stump-frontend";
    inherit (finalAttrs) src version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = finalAttrs.src + "/yarn.lock";
      hash = "sha256-yz+Ersi1fJdUUpi1ulTFxzpSIEU7o/ivKnL3+ICAotk=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      nodejs
    ];

    buildPhase = ''
      runHook preBuild

      pushd apps/web
      node ./node_modules/.bin/vite build
      popd

      runHook postBuild
    '';

    installPhase = ''
      mv ./apps/web/dist $out
    '';
  });

  __structuredAttrs = true;

  cargoHash = "sha256-434ffJRKlD9iL01v1dQmLatrtfpgDtxVdsryDNmlICg=";

  cargoBuildFlags = [
    "--package"
    "stump_server"
    "--bin"
    "stump_server"
  ];

  env.GIT_REV = "v${finalAttrs.version}";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  nativeCheckInputs = [
    cacert
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    openssl
    dbus
    glib
    gtk3
    webkitgtk_4_1
  ];

  postInstall = ''
    wrapProgram $out/bin/stump_server \
      --set-default STUMP_CONFIG_DIR /var/lib/stump/config \
      --set-default STUMP_CLIENT_DIR ${finalAttrs.frontend} \
      --set-default STUMP_PORT 10001 \
      --set-default STUMP_PROFILE release \
      --set-default PDFIUM_PATH ${pdfium}/lib/libpdfium.so \
      --set-default API_VERSION v1
  '';

  passthru = {
    tests = nixosTests.stump;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    homepage = "https://stumpapp.dev/";
    description = "A free and open source comics, manga and digital book server with OPDS support";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "stump_server";
    maintainers = with lib.maintainers; [
      jvanbruegge
      tr3foil
    ];
  };
})
