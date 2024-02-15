{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "choose-gui";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/chipsenkbeil/choose/releases/download/${version}/choose";
    hash = "sha256-HQ77LiosHWo5gwcmq3Qz2mTMIsou7Rnv1meAkMu54yU=";
  };

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/choose
    chmod +x $out/bin/choose
  '';

  meta = with lib; {
    description = "Fuzzy matcher for OS X that uses both std{in,out} and a native GUI";
    homepage = "https://github.com/chipsenkbeil/choose";

    license = licenses.mit;

    platforms = platforms.darwin;
    maintainers = with maintainers; [
      heywoodlh
    ];
    mainProgram = "choose";
  };
}
