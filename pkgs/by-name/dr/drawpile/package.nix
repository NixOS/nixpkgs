{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  extra-cmake-modules,
  rustc,
  rustPlatform,

  # common deps
  libzip,
  qt6Packages,

  # client deps
  ffmpeg,
  libsecret,
  libwebp,

  # optional client deps
  giflib,
  libvpx,
  miniupnpc,

  # optional server deps
  libmicrohttpd,
  libsodium,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd ? null,

  # options
  buildClient ? true,
  buildServer ? true,
  buildServerGui ? true, # if false builds a headless server
  buildExtraTools ? false,
}:

assert lib.assertMsg (
  buildClient || buildServer || buildExtraTools
) "You must specify at least one of buildClient, buildServer, or buildExtraTools.";

let
  clientDeps = with qt6Packages; [
    qtbase
    qtkeychain
    qtmultimedia
    qtsvg
    qttools
    ffmpeg
    libsecret
    libwebp
    # optional:
    giflib # gif animation export support
    libvpx # WebM video export
    miniupnpc # automatic port forwarding
  ];

  serverDeps = [
    # optional:
    libmicrohttpd # HTTP admin api
    libsodium # ext-auth support
  ]
  ++ lib.optional withSystemd systemd;

in
stdenv.mkDerivation rec {
  pname = "drawpile";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "drawpile";
    repo = "drawpile";
    rev = version;
    sha256 = "sha256-xcutcSpbFt+pb7QP1E/RG6iNnZwpfhIZTxr+1usLKHc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-VUX6J7TfxWpa07HPFZ8JzpltIwJUYAl5TABIpBmGYYo=";
  };

  nativeBuildInputs = [
    cargo
    extra-cmake-modules
    rustc
    rustPlatform.cargoSetupHook
    (
      if buildClient || buildServerGui then
        qt6Packages.wrapQtAppsHook
      else
        qt6Packages.wrapQtAppsNoGuiHook
    )
  ];

  buildInputs = [
    libzip
    qt6Packages.qtwebsockets
  ]
  ++ lib.optionals buildClient clientDeps
  ++ lib.optionals buildServer serverDeps;

  cmakeFlags = [
    (lib.cmakeFeature "INITSYS" (lib.optionalString withSystemd "systemd"))
    (lib.cmakeBool "CLIENT" buildClient)
    (lib.cmakeBool "SERVER" buildServer)
    (lib.cmakeBool "SERVERGUI" buildServerGui)
    (lib.cmakeBool "TOOLS" buildExtraTools)
  ];

  meta = {
    description = "Collaborative drawing program that allows multiple users to sketch on the same canvas simultaneously";
    homepage = "https://drawpile.net/";
    downloadPage = "https://drawpile.net/download/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  }
  // lib.optionalAttrs buildServer {
    mainProgram = "drawpile-srv";
  }
  // lib.optionalAttrs buildClient {
    mainProgram = "drawpile";
  };
}
