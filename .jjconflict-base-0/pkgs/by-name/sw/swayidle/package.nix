{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland-scanner
, wayland, wayland-protocols, runtimeShell
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
}:

stdenv.mkDerivation rec {
  pname = "swayidle";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    rev = version;
    hash = "sha256-/U6Y9H5ZqIJph3TZVcwr9+Qfd6NZNYComXuC1D9uGHg=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols ]
                ++ lib.optionals systemdSupport [ systemd ];

  mesonFlags = [ "-Dman-pages=enabled" "-Dlogind=${if systemdSupport then "enabled" else "disabled"}" ];

  postPatch = ''
    substituteInPlace main.c \
      --replace '"sh"' '"${runtimeShell}"'
  '';

  meta = with lib; {
    description = "Idle management daemon for Wayland";
    inherit (src.meta) homepage;
    longDescription = ''
      Sway's idle management daemon. It is compatible with any Wayland
      compositor which implements the KDE idle protocol.
    '';
    license = licenses.mit;
    mainProgram = "swayidle";
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
