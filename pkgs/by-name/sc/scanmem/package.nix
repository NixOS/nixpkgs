{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gobject-introspection,
  intltool,
  wrapGAppsHook3,
  procps,
  python3,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scanmem";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "scanmem";
    repo = "scanmem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SZ94BNMHcynq0uglP/j/QxTEELmrqJjN+NgjmQHU6J4=";
  };

  patches = [
    ./gettext-0.25.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    intltool
    wrapGAppsHook3
  ];
  buildInputs = [
    readline
    python3
  ];
  configureFlags = [ "--enable-gui" ];

  # we don't need to wrap the main executable, just the GUI
  dontWrapGApps = true;

  fixupPhase = ''
    runHook preFixup

    # replace the upstream launcher which does stupid things
    # also add procps because it shells out to `ps` and expects it to be procps
    makeWrapper ${python3}/bin/python3 $out/bin/gameconqueror \
      "''${gappsWrapperArgs[@]}" \
      --set PYTHONPATH "${python3.pkgs.makePythonPath [ python3.pkgs.pygobject3 ]}" \
      --prefix PATH : "${procps}/bin" \
      --add-flags "$out/share/gameconqueror/GameConqueror.py"

    runHook postFixup
  '';

  meta = {
    homepage = "https://github.com/scanmem/scanmem";
    description = "Memory scanner for finding and poking addresses in executing processes";
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
