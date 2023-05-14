{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, emacs
, tcl
, tclx
, espeak-ng
}:

stdenv.mkDerivation rec {
  pname = "emacspeak";
  version = "56.0";

  src = fetchFromGitHub {
    owner = "tvraman";
    repo = pname;
    rev = version;
    hash= "sha256-juy+nQ7DrG818/uTH6Dv/lrrzu8qzPWwi0sX7JrhHK8=";
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
    makeWrapper ${emacs}/bin/emacs $out/bin/emacspeak \
        --set DTK_PROGRAM "${placeholder "out"}/share/emacs/site-lisp/emacspeak/servers/espeak" \
        --set TCLLIBPATH "${tclx}/lib" \
        --add-flags '-l "${placeholder "out"}/share/emacs/site-lisp/emacspeak/lisp/emacspeak-setup.elc"'
  '';

  meta = with lib; {
    homepage = "https://github.com/tvraman/emacspeak/";
    description = "Emacs extension that provides spoken output";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
