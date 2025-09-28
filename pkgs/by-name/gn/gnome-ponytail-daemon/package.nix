{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  systemd,
  libei,
  libxkbcommon,
}:

stdenv.mkDerivation rec {
  pname = "gnome-ponytail-daemon";
  version = "0.0.12-dev";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ofourdan";
    repo = "gnome-ponytail-daemon";
    rev = "9dd3bda1816de216219232b8f6baec9f2d423ec6";
    hash = "sha256-0DvrYN/UP7SFNcVeh+3nuBUumiizFS+TAjFApu1oIIM=";
  };

  mesonFlags = [
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    systemd
    libei
    libxkbcommon
  ];

  meta = with lib; {
    description = "Sort of a bridge for dogtail for GNOME on Wayland";
    mainProgram = "gnome-ponytail-daemo";
    homepage = "https://gitlab.gnome.org/ofourdan/gnome-ponytail-daemon";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
