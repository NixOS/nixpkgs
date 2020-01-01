{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, glm
, libevdev
, libxml2
, wlroots
}:

stdenv.mkDerivation rec {
  pname = "wf-config";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    sha256 = "0pb2v71x0dv9s96wi20d9bc9rlxzr85rba7vny6751j7frqr4xf7";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    glm
    libevdev
    libxml2.dev
    wlroots
  ];

  meta = with stdenv.lib; {
    description = "A library for managing configuration files, written for wayfire";
    homepage = "https://wayfire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Thra11 wucke13 ];
  };
}
