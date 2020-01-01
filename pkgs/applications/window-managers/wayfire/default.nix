{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, wayland
, wlroots
, wayland-protocols
, cairo
, libdrm
, glm
, libinput
, libxkbcommon
, libevdev
, libjpeg
, wf-config
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    sha256 = "0sgcna258f6ccnyg4fm1vwvi9fk88dv8m7jpka1npvkk7c0bjc51";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    wayland
    wlroots
    wayland-protocols
    cairo
    libdrm
    glm
    libinput
    libxkbcommon
    libjpeg
    wf-config
  ];

  postInstall = ''
    cp ../wayfire.ini.default $out/share/
  '';

  meta = with stdenv.lib; {
    description = "3D wayland compositor";
    homepage = https://wayfire.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Thra11 ];
  };
}
