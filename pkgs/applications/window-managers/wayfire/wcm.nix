{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, wayland, wrapGAppsHook
, gnome3, libevdev, libxml2, wayfire, wayland-protocols, wf-config, wf-shell
}:

stdenv.mkDerivation rec {
  pname = "wcm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wcm";
    rev = "v${version}";
    sha256 = "1b22gymqfn0c49nf39676q5bj25rxab874iayiq31cmn14r30dyg";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland wrapGAppsHook ];
  buildInputs = [
    gnome3.gtk libevdev libxml2 wayfire wayland
    wayland-protocols wf-config wf-shell
  ];

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
