{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libevent,
  file,
  qrencode,
  openssl,
  miniupnpc,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pshs";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "projg2";
    repo = "pshs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sfhhxeQa0rmBerfAemuHou0N001Zq5Hh7s7utxLQHOI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libevent
    file
    qrencode
    openssl
    miniupnpc
  ];

  strictDeps = true;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Pretty small HTTP server - a command-line tool to share files";
    mainProgram = "pshs";
    homepage = "https://github.com/mgorny/pshs";
    sourceProvenance = [ sourceTypes.fromSource ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
})
