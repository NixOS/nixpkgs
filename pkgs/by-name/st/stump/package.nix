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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stump";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "stumpapp";
    repo = "stump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ERERTzoh0RoWtVNrOejiyFu7ZmSVgUVGFaTsj36Je48=";
  };

  frontend = stdenv.mkDerivation (_: {
    pname = "stump-frontend";
    inherit (finalAttrs) src version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = finalAttrs.src + "/yarn.lock";
      hash = "sha256-x5aZLRhNmoxcrMOQNvNDfuJCfc0ezYazVGm17v3CwqE=";
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

  cargoHash = "sha256-4qCxyoo1WyurXLEw5Nq291Tglds0Lg1LGHfgZxsoZBQ=";

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
  ];

  buildInputs = [
    openssl
    dbus
    glib
    gtk3
    webkitgtk_4_1
  ];

  preCheck = ''
    export HOME=$TMP
  '';

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
    platforms = [ "x86_64-linux" ];
    mainProgram = "stump_server";
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
})
