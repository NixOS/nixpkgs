{ lib, stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation {
  pname = "bwa";
  version = "unstable-2022-09-23";

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "bwa";
    rev = "139f68fc4c3747813783a488aef2adc86626b01b";
    hash = "sha256-8u35lTK6gBKeapYoIkG9MuJ/pyy/HFA2OiPn+Ml2C6c=";
  };

  buildInputs = [ zlib ];

  # Avoid hardcoding gcc to allow environments with a different
  # C compiler to build
  preConfigure = ''
    sed -i '/^CC/d' Makefile
  '';

  makeFlags = lib.optional stdenv.hostPlatform.isStatic "AR=${stdenv.cc.targetPrefix}ar";

  # it's unclear which headers are intended to be part of the public interface
  # so we may find ourselves having to add more here over time
  installPhase = ''
    runHook preInstall

    install -vD -t $out/bin bwa
    install -vD -t $out/lib libbwa.a
    install -vD -t $out/include bntseq.h
    install -vD -t $out/include bwa.h
    install -vD -t $out/include bwamem.h
    install -vD -t $out/include bwt.h

    runHook postInstall
  '';

  meta = with lib; {
    description = "A software package for mapping low-divergent sequences against a large reference genome, such as the human genome";
    mainProgram = "bwa";
    license     = licenses.gpl3Plus;
    homepage    = "https://bio-bwa.sourceforge.net/";
    maintainers = with maintainers; [ luispedro ];
    platforms = platforms.unix;
  };
}
