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
  protobuf_21,
  boost,

  gsettings-desktop-schemas,

  nix-update-script,
}:
let
  version = "0.9.3";
in
stdenv.mkDerivation {
  pname = "glight";
  inherit version;

  src = fetchFromGitHub {
    owner = "aroffringa";
    repo = "glight";
    tag = "v${version}";
    hash = "sha256-b5GO692NJ5AIRhA4v168DDYoFEVwNETrYyPBv+zuZFY=";
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
    protobuf_21 # required by OLA with strictDeps
    boost

    gsettings-desktop-schemas
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ola ]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/aroffringa/glight";
    description = "DMX controller software for live control of stage lighting";
    maintainers = with lib.maintainers; [ axka ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "glight";
  };
}
