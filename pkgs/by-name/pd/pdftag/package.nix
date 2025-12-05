{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  vala,
  ninja,
  gtk3,
  poppler,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "pdftag";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "arrufat";
    repo = "pdftag";
    rev = "v${version}";
    sha256 = "1paj8hs27akzsivn01a30fl3zx5gfn1h89wxg2m72fd806hk0hql";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook3
    vala
  ];
  buildInputs = [
    gtk3
    poppler
  ];

  meta = with lib; {
    description = "Edit metadata found in PDFs";
    license = licenses.gpl3;
    platforms = platforms.unix;
    mainProgram = "pdftag";
  };
}
