{ lib, stdenv, fetchurl, jdk, bash, coreutils, substituteAll, nixosTests, jna }:

let
  version = "build01494";
  freenet_ext = fetchurl {
    url = "https://github.com/freenet/fred/releases/download/${version}/freenet-ext.jar";
    sha256 = "sha256-MvKz1r7t9UE36i+aPr72dmbXafCWawjNF/19tZuk158=";
  };
  bcprov = fetchurl {
    url = "https://github.com/freenet/fred/releases/download/${version}/bcprov-jdk15on-1.59.jar";
    sha256 = "sha256-HDHkTjMdJeRtKTs+juLQcCimfbAR50yyRDKFrtHVnIU=";
  };
  seednodes = fetchurl {
    url = "https://downloads.freenetproject.org/alpha/opennet/seednodes.fref";
    sha256 = "08awwr8n80b4cdzzb3y8hf2fzkr1f2ly4nlq779d6pvi5jymqdvv";
  };

  freenet-jars = stdenv.mkDerivation {
    pname = "freenet-jars";
    inherit version;

    src = fetchurl {
      url = "https://github.com/freenet/fred/releases/download/${version}/freenet.jar";
      sha256 = "sha256-1Pjc8Ob4EN7N05QkGTMKBn7z3myTDaQ98N48nNSLstg=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/freenet
      ln -s ${bcprov} $out/share/freenet/bcprov.jar
      ln -s ${freenet_ext} $out/share/freenet/freenet-ext.jar
      ln -s ${jna}/share/java/jna-platform.jar $out/share/freenet/jna_platform.jar
      ln -s ${jna}/share/java/jna.jar $out/share/freenet/jna.jar
      ln -s $src $out/share/freenet/freenet.jar
    '';
  };

in stdenv.mkDerivation {
  pname = "freenet";
  inherit version;

  src = substituteAll {
    src = ./freenetWrapper;
    inherit bash coreutils jdk seednodes;
    freenet = freenet-jars;
  };

  dontUnpack = true;

  passthru.tests = { inherit (nixosTests) freenet; };

  installPhase = ''
    mkdir -p $out/bin
    install -Dm555 $src $out/bin/freenet
    ln -s ${freenet-jars}/share $out/share
  '';

  meta = {
    description = "Decentralised and censorship-resistant network";
    homepage = "https://freenetproject.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nagy ];
    platforms = with lib.platforms; linux;
    changelog = "https://github.com/freenet/fred/blob/build${version}/NEWS.md";
  };
}
