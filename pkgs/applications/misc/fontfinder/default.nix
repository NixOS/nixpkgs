{ lib
, stdenv
, fetchFromGitHub
, cargo
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook
, gdk-pixbuf
, gtk3
, libsoup_3
, webkitgtk_4_1
}:

stdenv.mkDerivation rec {
  pname = "fontfinder";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = "fontfinder";
    rev = version;
    hash = "sha256-C4KqEdqToVnPXFPWvNkl/md9L2W4NxRd5jvZ4E7CtfA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-PXO8E41KHPNOR527gs2vM3J9JMG0PWi8Eg/13UCkr3U=";
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    gtk3
    libsoup_3
    webkitgtk_4_1
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "GTK application for browsing and installing fonts from Google's font archive";
    homepage = "https://github.com/mmstick/fontfinder";
    changelog = "https://github.com/mmstick/fontfinder/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fontfinder-gtk";
  };
}
