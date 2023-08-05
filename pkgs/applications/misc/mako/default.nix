{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, scdoc
, systemd, pango, cairo, gdk-pixbuf, jq
, wayland, wayland-protocols
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mako";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sUFMcCrc5iNPeAmRbqDaT/n8OIlFJEwJTzY1HMx94RU=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-protocols wrapGAppsHook ];
  buildInputs = [ systemd pango cairo gdk-pixbuf wayland ];

  mesonFlags = [
    "-Dzsh-completions=true"
    "-Dsd-bus-provider=libsystemd"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ systemd /* for busctl */ jq ]}"
    )
  '';

  meta = with lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = "https://wayland.emersion.fr/mako/";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir synthetica ];
    platforms = platforms.linux;
  };
}
