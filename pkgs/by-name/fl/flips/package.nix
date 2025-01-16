{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  libdivsufsort,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "flips";
  version = "189";

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
    tag = "v${version}";
    hash = "sha256-xTqWjDgdSsOLEd7OfC8s/oG9EbHcxglSj7ebhT31/Vo=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libdivsufsort
  ];

  patches = [ ./use-system-libdivsufsort.patch ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Patcher for IPS and BPS files";
    homepage = "https://github.com/Alcaro/Flips";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
    mainProgram = "flips";
  };
}
