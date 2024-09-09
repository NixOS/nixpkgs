{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, systemd
, pango
, cairo
, gdk-pixbuf
, jq
, bash
, wayland
, wayland-scanner
, wayland-protocols
, wrapGAppsHook3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mako";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mako";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-QtYtondP7E5QXLRnmcaOQlAm9fKXctfjxeUFqK6FnnE=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-protocols wrapGAppsHook3 wayland-scanner ];
  buildInputs = [ systemd pango cairo gdk-pixbuf wayland ];

  mesonFlags = [
    "-Dzsh-completions=true"
    "-Dsd-bus-provider=libsystemd"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ systemd /* for busctl */ jq bash ]}"
    )
  '';

  meta = {
    description = "Lightweight Wayland notification daemon";
    homepage = "https://wayland.emersion.fr/mako/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir synthetica ];
    platforms = lib.platforms.linux;
    mainProgram = "mako";
  };
})
