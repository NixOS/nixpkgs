{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  autoreconfHook,
  dbus,
  pango,
  pcre2,
  pkg-config,
  tmux,
  vte,
  wrapGAppsHook3,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "germinal";
  version = "26";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "Germinal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HUi+skF4bJj5CY2cNTOC4tl7jhvpXYKqBx2rqKzjlo0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    appstream-glib
    dbus
    pango
    pcre2
    vte
  ];

  configureFlags = [
    "--with-dbusservicesdir=${placeholder "out"}/etc/dbus-1/system-services/"
  ];

  dontWrapGApps = true;

  fixupPhase = ''
    runHook preFixup
    wrapProgram $out/bin/germinal \
     --prefix PATH ":" "${lib.makeBinPath [ tmux ]}" \
      "''${gappsWrapperArgs[@]}"
    runHook postFixup
  '';

  passthru.tests.test = nixosTests.terminal-emulators.germinal;

  meta = {
    description = "Minimal terminal emulator";
    homepage = "https://github.com/Keruspe/Germinal";
    license = lib.licenses.gpl3Plus;
    mainProgram = "germinal";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
