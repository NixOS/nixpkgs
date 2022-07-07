{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, appstream-glib
, dbus
, pango
, pcre2
, tmux
, vte
, wrapGAppsHook
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "germinal";
  version = "26";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "Germinal";
    rev = "v${version}";
    sha256 = "sha256-HUi+skF4bJj5CY2cNTOC4tl7jhvpXYKqBx2rqKzjlo0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config wrapGAppsHook ];
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

  meta = with lib; {
    description = "A minimal terminal emulator";
    homepage = "https://github.com/Keruspe/Germinal";
    license = with licenses; gpl3Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
