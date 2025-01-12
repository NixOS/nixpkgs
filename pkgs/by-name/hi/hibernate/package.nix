{
  lib,
  stdenv,
  fetchurl,
  gawk,
}:

let
  version = "2.0";
in
stdenv.mkDerivation {
  pname = "hibernate";
  inherit version;
  src = fetchurl {
    url = "http://tuxonice.nigelcunningham.com.au/files/hibernate-script-${version}.tar.gz";
    sha256 = "0ib5bac3spbcwmhf8f9apjbll8x7fgqj4k1s5q3srijh793rfifh";
  };

  patches = [
    ./install.patch
    ./gen-manpages.patch
    ./hibernate.patch
  ];

  buildInputs = [ gawk ];

  installPhase = ''
    # FIXME: Storing config files under `$out/etc' is not very useful.

    substituteInPlace "hibernate.sh" --replace \
      'SWSUSP_D="/etc/hibernate"' "SWSUSP_D=\"$out/etc/hibernate\""

    # Remove all references to `/bin' and `/sbin'.
    for i in scriptlets.d/*
    do
      substituteInPlace "$i" --replace "/bin/" "" --replace "/sbin/" ""
    done

    PREFIX="$out" CONFIG_PREFIX="$out" ./install.sh

    ln -s "$out/share/hibernate/scriptlets.d" "$out/etc/hibernate"
  '';

  meta = {
    description = "`hibernate' script for swsusp and Tux-on-Ice";
    mainProgram = "hibernate";
    longDescription = ''
      This package provides the `hibernate' script, a command-line utility
      that saves the computer's state to disk and switches it off, turning
      it into "hibernation".  It works both with Linux swsusp and Tux-on-Ice.
    '';

    license = lib.licenses.gpl2Plus;
    homepage = "http://www.tuxonice.net/";
    platforms = lib.platforms.linux;
  };
}
