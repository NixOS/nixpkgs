{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  protobuf_29,
  zlib,
  sqlite,
  udev,
  fmt,
  wxGTK32,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "fluxengine";
  version = "unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "davidgiven";
    repo = "fluxengine";
    rev = "5293e1c18bd5c36f197ba496435388d8019fd5a3";
    hash = "sha256-oi7/VHT1OA9rt1W6lW3ei+PRYB2qOUQ2U49Uo/kk2ps=";
  };

  buildInputs = [
    protobuf_29
    zlib
    sqlite
    udev
    fmt
  ];
  nativeBuildInputs = [
    pkg-config
    python3
    wxGTK32
    wrapGAppsHook3
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm555 {brother120tool,brother240tool,fluxengine,fluxengine-gui,upgrade-flux-file} $out/bin
  '';

  meta = {
    description = "PSOC5 floppy disk imaging interface";
    homepage = "https://github.com/davidgiven/fluxengine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "fluxengine";
    platforms = lib.platforms.all;
  };
}
