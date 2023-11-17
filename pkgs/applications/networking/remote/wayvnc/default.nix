{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, wayland-scanner
, aml
, jansson
, libxkbcommon
, mesa
, neatvnc
, pam
, pixman
, wayland
}:

stdenv.mkDerivation rec {
  pname = "wayvnc";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6at0p1Xc25K5l6sq2uMWpaLVvZMNlWC0ybyZyrIw41I=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    aml
    jansson
    libxkbcommon
    mesa
    neatvnc
    pam
    pixman
    wayland
  ];

  mesonFlags = [
    (lib.mesonBool "tests" true)
  ];

  doCheck = true;

  meta = with lib; {
    description = "A VNC server for wlroots based Wayland compositors";
    longDescription = ''
      This is a VNC server for wlroots based Wayland compositors. It attaches
      to a running Wayland session, creates virtual input devices and exposes a
      single display via the RFB protocol. The Wayland session may be a
      headless one, so it is also possible to run wayvnc without a physical
      display attached.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/any1/wayvnc/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickcao ];
  };
}
