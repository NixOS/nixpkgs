{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  extra-cmake-modules,
  rustc,
  rustPlatform,
  fetchpatch,

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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "drawpile";
    repo = "drawpile";
    rev = version;
    sha256 = "sha256-0paLKxAEvlbExq426xTekBt+Dkphx7Wg/AtpYN3f/4w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-u9fRbxKeQSou9Umw4EaqzzzDiN4zhyfx9sWnlZpfpxU=";
  };

  patches = [
    # Remove for 2.3.1
    # QT updated and broke some functionality so we have to get the commit that fixes it from upstream
    (fetchpatch {
      name = "qt-6.10.1.patch";
      url = "https://github.com/drawpile/Drawpile/commit/c4f69f79b1cb0d25e68b49e807ce6773ddb9dd3c.patch";
      hash = "sha256-Z8mcPux8tvK5y1GirfKq1X9+kxHDIrnSLTd2MCSIxTg=";
    })
  ];

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
    maintainers = with lib.maintainers; [
      fgaz
      qubic
    ];
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
