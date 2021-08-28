{ stdenv, fetchurl, makeWrapper, emacs, tcl, tclx, espeak-ng, lib }:

stdenv.mkDerivation rec {
  pname = "emacspeak";
  version = "51.0";

  src = fetchurl {
    url = "https://github.com/tvraman/emacspeak/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "09a0ywxlqa8jmc0wmvhaf7bdydnkyhy9nqfsdqcpbsgdzj6qpg90";
  };

  nativeBuildInputs = [ makeWrapper emacs ];
  buildInputs = [ tcl tclx espeak-ng ];

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
        --set DTK_PROGRAM "${espeak-ng}/bin/espeak" \
        --add-flags '-l "${placeholder "out"}/share/emacs/site-lisp/emacspeak/lisp/emacspeak-setup.elc"'
  '';

  meta = {
    homepage = "https://github.com/tvraman/emacspeak/";
    description = "Emacs extension that provides spoken output";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
