{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bashmount";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "jamielinux";
    repo = "bashmount";
    tag = finalAttrs.version;
    sha256 = "1irw47s6i1qwxd20cymzlfw5sv579cw877l27j3p66qfhgadwxrl";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bashmount $out/bin

    mkdir -p $out/etc
    cp bashmount.conf $out/etc

    mkdir -p $out/share/man/man1
    gzip -c -9 bashmount.1 > bashmount.1.gz
    cp bashmount.1.gz $out/share/man/man1

    mkdir -p $out/share/doc/bashmount
    cp COPYING $out/share/doc/bashmount
    cp NEWS    $out/share/doc/bashmount
  '';

  meta = {
    homepage = "https://github.com/jamielinux/bashmount";
    description = "Menu-driven bash script for the management of removable media with udisks";
    mainProgram = "bashmount";
    maintainers = [ lib.maintainers.koral ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
