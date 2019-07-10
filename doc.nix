{
  stdenv
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "cndrvcups-doc";
  version = "2.71";

  src = ./Doc;

  # install directions based on arch PKGBUILD file
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=capt-src

  installPhase = ''
    mkdir -p $out

    # Custom License
    install -dm755 $out/share/licenses
    install -Dm664 LICENSE-EN.txt $out/share/licenses/LICENSE-EN.txt

    # Guide & README
    install -Dm664 guide-capt-2.7xUK.tar.gz $out/share/doc/capt-src/guide-capt-2.7xUK.tar.gz
    install -Dm664 README-capt-2.71UK.txt $out/share/doc/capt-src/README-capt-2.71UK.txt
    install -dm755 $out/share/ppd/cupsfilters
  '';

  meta = with stdenv.lib; {
    description = "Canon CAPT driver";
    longDescription = ''
      Canon CAPT driver
    '';
  };
}
