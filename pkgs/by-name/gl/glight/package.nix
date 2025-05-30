{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,

  gtkmm3,
  aubio,
  flac,
  alsa-lib,
  ola,
  protobuf,
  libxml2,
  boost,

  gsettings-desktop-schemas,

  nix-update-script,
}:
let
  version = "0.9.2";
in
stdenv.mkDerivation {
  pname = "glight";
  inherit version;

  src = fetchFromGitHub {
    owner = "aroffringa";
    repo = "glight";
    tag = "v${version}";
    hash = "sha256-2le9peRFOkpdeITIGx4g9v/6vhfsadn/rRYTLgJMtqA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config

    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    aubio
    flac
    alsa-lib
    ola
    protobuf # required by OLA with strictDeps
    libxml2
    boost

    gsettings-desktop-schemas
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/aroffringa/glight";
    description = "DMX controller software for live control of stage lighting";
    maintainers = with lib.maintainers; [ axka ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "glight";
  };
}
