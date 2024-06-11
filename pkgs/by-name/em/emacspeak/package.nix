{ lib
, emacs
, espeak-ng
, fetchFromGitHub
, makeWrapper
, stdenv
, tcl
, tclx
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emacspeak";
  version = "59.0";

  src = fetchFromGitHub {
    owner = "tvraman";
    repo = "emacspeak";
    rev = finalAttrs.version;
    hash = "sha256-npS/wlqI7nBde/2S/rzp79jdfYXIIhgsVs5VizxEDAQ=";
  };

  nativeBuildInputs = [
    emacs
    makeWrapper
  ];

  buildInputs = [
    espeak-ng
    tcl
    tclx
  ];

  strictDeps = true;

  preConfigure = ''
    make config
  '';

  postBuild = ''
    make -C servers/native-espeak PREFIX=$out "TCL_INCLUDE=${tcl}/include"
  '';

  postInstall = ''
    make -C servers/native-espeak PREFIX=$out install
    local d=$out/share/emacs/site-lisp/emacspeak/
    install -d -- "$d"
    cp -a .  "$d"
    find "$d" \( -type d -or \( -type f -executable \) \) -execdir chmod 755 {} +
    find "$d" -type f -not -executable -execdir chmod 644 {} +
    makeWrapper ${lib.getExe emacs} $out/bin/emacspeak \
        --set DTK_PROGRAM "${placeholder "out"}/share/emacs/site-lisp/emacspeak/servers/espeak" \
        --set TCLLIBPATH "${tclx}/lib" \
        --add-flags '-l "${placeholder "out"}/share/emacs/site-lisp/emacspeak/lisp/emacspeak-setup.elc"'
  '';

  meta = {
    homepage = "https://github.com/tvraman/emacspeak/";
    description = "Emacs extension that provides spoken output";
    changelog = "https://github.com/tvraman/emacspeak/blob/${finalAttrs.src.rev}/etc/NEWS";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "emacspeak";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
    # Emacspeak requires a minimal Emacs version; let's use the broken flag
    broken = lib.versionOlder (lib.getVersion emacs) "29.1";
  };
})
