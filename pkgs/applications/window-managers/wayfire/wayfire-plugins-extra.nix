{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayfire
, wf-config
, gtkmm3
, gtk-layer-shell
, libxkbcommon
, xcbutilwm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-hnsRwIrl0+pRKhRlrF/Wdlu6HkzLfYukGk4Hzx3wNeo=";
  };

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
