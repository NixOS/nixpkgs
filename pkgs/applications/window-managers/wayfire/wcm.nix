{ stdenv
, fetchFromGitHub
, buildEnv
, meson
, ninja
, pkgconfig
, wrapGAppsHook
, glm
, gtkmm3
, libevdev
, libxml2
, wayfire
, wayland
, wayland-protocols
, wf-config
, wf-shell
}:

let 
  env = buildEnv {
    name = "metadata";
    paths = [ "${wayfire}/share/wayfire/metadata" "${wf-shell}/share/wayfire/metadata"  ];
  };
in stdenv.mkDerivation rec {
  pname = "wcm";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    sha256 = "0irypa0814nmsmi9s8wxwfs507w41g41zjv8dkp0fdhg0429zxwa";
  };
  
  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    glm
    gtkmm3
    libevdev
    libxml2
    wayfire
    wayland
    wayland-protocols
    wf-config
  ];

  prePatch = ''
    sed "s|wayfire.get_variable(pkgconfig: 'metadatadir')|'${env}'|g" -i meson.build
  '';

  meta = with stdenv.lib; {
    description = "Wayfire Config Manager";
    homepage = "https://wayfire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Thra11 wucke13 ];
  };
}
