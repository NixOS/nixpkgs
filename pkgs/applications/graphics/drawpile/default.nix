{
  stdenv,
  lib,
  mkDerivation,
  fetchFromGitHub,
  extra-cmake-modules,

  # common deps
  karchive,

  # client deps
  qtbase,
  qtkeychain,
  qtmultimedia,
  qtsvg,
  qttools,
  libsecret,

  # optional client deps
  giflib,
  kdnssd,
  libvpx,
  miniupnpc,
  qtx11extras, # kis

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
  enableKisTablet ? false, # enable improved graphics tablet support
}:

with lib;

let
  clientDeps = [
    qtbase
    qtkeychain
    qtmultimedia
    qtsvg
    qttools
    libsecret
    # optional:
    giflib # gif animation export support
    kdnssd # local server discovery with Zeroconf
    libvpx # WebM video export
    miniupnpc # automatic port forwarding
  ];

  serverDeps = [
    # optional:
    libmicrohttpd # HTTP admin api
    libsodium # ext-auth support
  ] ++ optional withSystemd systemd;

  kisDeps = [
    qtx11extras
  ];

  boolToFlag = bool: if bool then "ON" else "OFF";

in
mkDerivation rec {
  pname = "drawpile";
  version = "2.1.20";

  src = fetchFromGitHub {
    owner = "drawpile";
    repo = "drawpile";
    rev = version;
    sha256 = "sha256-HjGsaa2BYRNxaQP9e8Z7BkVlIKByC/ta92boGbYHRWQ=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs =
    [
      karchive
    ]
    ++ optionals buildClient clientDeps
    ++ optionals buildServer serverDeps
    ++ optionals enableKisTablet kisDeps;

  cmakeFlags = [
    "-Wno-dev"
    "-DINITSYS=systemd"
    "-DCLIENT=${boolToFlag buildClient}"
    "-DSERVER=${boolToFlag buildServer}"
    "-DSERVERGUI=${boolToFlag buildServerGui}"
    "-DTOOLS=${boolToFlag buildExtraTools}"
    "-DKIS_TABLET=${boolToFlag enableKisTablet}"
  ];

  meta = {
    description = "A collaborative drawing program that allows multiple users to sketch on the same canvas simultaneously";
    mainProgram = "drawpile-srv";
    homepage = "https://drawpile.net/";
    downloadPage = "https://drawpile.net/download/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
