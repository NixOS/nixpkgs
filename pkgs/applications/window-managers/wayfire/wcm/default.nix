{ stdenv, meson, ninja
, fetchFromGitHub, wayfire
, wf-shell, pkg-config
, libevdev, wayland
, wayland-protocols
, libxml2, gtk3, glm
, wf-config
}:

stdenv.mkDerivation rec {
  pname = "wcm";
  version = "5d935e0727ab976c85690669083addc9c21ee298";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    sha256 = "sha256-Nrz/Em80+C8uTUf0+Ny/WLcMKFVRKAzXaeIp3m7NsnU=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    wayfire wf-shell
    libevdev wayland
    wayland-protocols
    libxml2 gtk3 glm
    wf-config
  ];

  mesonFlags = [
    "-Dwf_shell=enabled"
    "-Dwayfire_config_file_path=~/.config/wayfire.ini"
    "-Dwf_shell_config_file_path=~/.config/wf-shell.ini"
  ];

  meta = with stdenv.lib; {
    description = "Wayfire Config Manager";
    homepage = https://wayfire.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ishan ];
    platforms = platforms.linux;
  };
}
