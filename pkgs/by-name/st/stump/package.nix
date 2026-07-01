{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  rustPlatform,
  nodejs,
  pdfium-binaries,
  openssl,
  dbus,
  glib,
  gtk3,
  webkitgtk_4_1,
  cacert,
  pkg-config,
  makeWrapper,
}:
let
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "stumpapp";
    repo = "stump";
    tag = "v${version}";
    hash = "sha256-kstMk4HJopLHW22ynVZF0itWUixwiDkbsMUpYMvw1Ag=";
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "stump-frontend";
    inherit src version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = finalAttrs.src + "/yarn.lock";
      hash = "sha256-Zh0GmxzDZ9YkUVK9i4cT4NKm83Rgcdi1qGmvA8RdDUM=";
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
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stump";
  inherit src version;

  __structuredAttrs = true;

  cargoHash = "sha256-ZFIoxlArbhD+kZfX8K1iWmIaFSPfk9DeO9mL9PUZCnI=";

  cargoBuildFlags = [
    "--package"
    "stump_server"
    "--bin"
    "stump_server"
  ];

  env.GIT_REV = "v${version}";

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
      --set-default STUMP_CLIENT_DIR ${frontend} \
      --set-default STUMP_PORT 10001 \
      --set-default STUMP_PROFILE release \
      --set-default PDFIUM_PATH ${pdfium-binaries}/lib/libpdfium.so \
      --set-default API_VERSION v1
  '';

  passthru.tests = nixosTests.stump;

  meta = {
    homepage = "https://stumpapp.dev/";
    description = "A free and open source comics, manga and digital book server with OPDS support";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "stump_server";
  };
})
