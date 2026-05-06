{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  librsvg,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "inklingreader";
  version = "0.8-unstable-2022-11-27";

  src = fetchFromGitHub {
    owner = "roelj";
    repo = "inklingreader";
    rev = "e83be4ed1f397e314e22573275785776879e72b3";
    hash = "sha256-UWnheVwDUsxUj0ku9A4o+XWKUPZeoRu/1iVQlk4d6qg=";
  };

  patches = [
    # https://github.com/roelj/inklingreader/pull/54
    ./fix-gcc15.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    librsvg
    libusb1
  ];

  meta = {
    homepage = "https://github.com/roelj/inklingreader";
    description = "GNU/Linux-friendly version of the Wacom Inkling SketchManager";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ totoroot ];
    platforms = lib.platforms.linux;
    mainProgram = "inklingreader";
  };
}
