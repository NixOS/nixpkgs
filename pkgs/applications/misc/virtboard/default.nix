{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, wrapGAppsHook
, pixman
, libxkbcommon
, libpng
, wayland
, wayland-protocols
, cairo
}:

stdenv.mkDerivation rec {
  pname = "virtboard";
  version = "unstable-2019-02-22";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "f36cc2051c878652aa6c5a8e5aa03cc2e1509baf";
    sha256 = "0qdfmvq1nsfh2kilvasq9x0cqdm4w09pqpbf3p52k4yqyk4fk5kx";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    pixman
    libxkbcommon
    libpng
    wayland
    wayland-protocols
    cairo
  ];

  meta = with stdenv.lib; {
    description = "A basic keyboard, blazing the path of modern Wayland keyboards";
    homepage = https://source.puri.sm/Librem5/virtboard;
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
