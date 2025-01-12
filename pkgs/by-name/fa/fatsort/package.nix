{
  lib,
  stdenv,
  fetchurl,
  help2man,
  libiconv,
}:

stdenv.mkDerivation rec {
  version = "1.6.5.640";
  pname = "fatsort";

  src = fetchurl {
    url = "mirror://sourceforge/fatsort/${pname}-${version}.tar.xz";
    sha256 = "sha256-Yw7OVtnrOlVSSvCuw6reeFQ2DrqUkXKmz7R2jLj75C4=";
  };

  buildInputs = [
    help2man
    libiconv
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"

    "UNAME_O=${stdenv.hostPlatform.uname.system}"
    "UNAME_S=${stdenv.hostPlatform.uname.system}"
  ];

  # make install target is broken (DESTDIR usage is insane)
  # it's easier to just skip make and install manually
  installPhase = ''
    runHook preInstall
    install -D -m 755 ./src/fatsort   $out/bin/fatsort
    install -D -m 644 ./man/fatsort.1 $out/man/man1/fatsort.1
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://fatsort.sourceforge.net/";
    description = "Sorts FAT partition table, for devices that don't do sorting of files";
    maintainers = [ maintainers.kovirobi ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "fatsort";
  };
}
