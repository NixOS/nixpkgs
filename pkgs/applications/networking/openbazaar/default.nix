{ lib, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "openbazaar";
  version = "0.14.6";

  suffix = {
    i686-linux    = "linux-386";
    x86_64-darwin = "darwin-10.6-amd64";
    x86_64-linux  = "linux-amd64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/OpenBazaar/openbazaar-go/releases/download/v${version}/${pname}-go-${suffix}";
    sha256 = {
      i686-linux    = "1cmv3gyfd6q7y6yn6kigksy2abkq5b8mfgk51d04ky1ckgbriaqq";
      x86_64-darwin = "0n32a0pyj1k2had3imimdyhdhyb285y1dj04f7g3jajmy5zndaxx";
      x86_64-linux  = "105i5yl2yvhcvyh1wf35kqq1qyxgbl9j2kxs6yshsk14b2p02j5i";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;
  preferLocalBuild = true;

  installPhase = ''
    install -D $src $out/bin/openbazaard
  '';

  postFixup = lib.optionalString (!stdenv.isDarwin) ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/openbazaard
  '';

  meta = with lib; {
    description = "Decentralized Peer to Peer Marketplace for Bitcoin - daemon";
    homepage = "https://www.openbazaar.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "i686-linux" "x86_64-darwin" "x86_64-linux" ];
  };
}
