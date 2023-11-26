{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, wayfire
, wf-config
, gtkmm3
, gtk-layer-shell
, libevdev
, libinput
, libxkbcommon
, xcbutilwm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-OVyP1AgZ1d9DXFkbHnROwtSQIquEX5ccVIkcmCdDZtA=";
  };

  patches = [
    (fetchpatch {
      name = "check-dependency-libevdev.patch";
      url = "https://github.com/WayfireWM/wayfire-plugins-extra/commit/f3bbf1fcbafd28016e36be7a5043bd82574ac9e4.patch";
      hash = "sha256-8X1lpf8H8NuA845cIslahKDQKW/IA/KiMExU4Snk72o=";
    })
  ];

  postPatch = ''
    substituteInPlace metadata/meson.build \
      --replace "wayfire.get_variable(pkgconfig: 'metadatadir')" "join_paths(get_option('prefix'), 'share/wayfire/metadata')"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    wayfire
    wf-config
    libevdev
    libinput
    libxkbcommon
    xcbutilwm
    gtkmm3
    gtk-layer-shell
  ];

  mesonFlags = [ "--sysconfdir /etc" ];

  meta = {
    homepage = "https://github.com/WayfireWM/wayfire-plugins-extra";
    description = "Additional plugins for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
