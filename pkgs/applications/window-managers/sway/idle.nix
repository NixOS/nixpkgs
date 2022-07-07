{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland-scanner
, wayland, wayland-protocols, runtimeShell
, systemdSupport ? stdenv.isLinux, systemd
}:

stdenv.mkDerivation rec {
  pname = "swayidle";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    rev = version;
    sha256 = "06iq12p4438d6bv3jlqsf01wjaxrzlnj1bnicn41kad563aq41xl";
  };

  strictDeps = true;
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols ]
                ++ lib.optionals systemdSupport [ systemd ];

  mesonFlags = [ "-Dman-pages=enabled" "-Dlogind=${if systemdSupport then "enabled" else "disabled"}" ];

  # Remove the `%zu` patch for the next release after 1.7.1.
  # https://github.com/swaywm/swayidle/commit/e81d40fca7533f73319e76e42fa9694b21cc9e6e
  postPatch = ''
    substituteInPlace main.c \
      --replace '%lu' '%zu' \
      --replace '"sh"' '"${runtimeShell}"'
  '';

  meta = with lib; {
    description = "Idle management daemon for Wayland";
    longDescription = ''
      Sway's idle management daemon. It is compatible with any Wayland
      compositor which implements the KDE idle protocol.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
