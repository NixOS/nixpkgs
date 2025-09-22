{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "actkbd";
  version = "0.2.8";

  src = fetchurl {
    url = "http://users.softlab.ece.ntua.gr/~thkala/projects/actkbd/files/actkbd-${version}.tar.bz2";
    hash = "sha256-lepkO44ba9i5vDQtSgHrRjlJjhUymqQjKffMg8s868Y=";
  };

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace /etc $out/etc
  '';

  postInstall = ''
    mkdir -p $out/share/doc/actkbd
    cp -r README samples $out/share/doc/actkbd
  '';

  meta = {
    description = "Keyboard shortcut daemon";
    longDescription = ''
      actkbd is a simple daemon that binds actions to keyboard events
      directly on evdev interface (that is, no X11 required). It
      recognises key combinations and can handle press, repeat and
      release events.
    '';
    license = lib.licenses.gpl2Only;
    homepage = "http://users.softlab.ece.ntua.gr/~thkala/projects/actkbd/";
    platforms = lib.platforms.linux;
    mainProgram = "actkbd";
  };
}
