{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "agevault";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/ndavd/agevault/releases/download/v${version}/agevault_${version}_linux_amd64.tar.gz";
    sha256 = "0w2j3dis7q5gp39c58h0sg6kldjsjgcrnmnyk0312apixkrh49a3";
  };

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin
    chmod +x $out/bin/agevault
  '';

  meta = with lib; {
    description = "Directory encryption tool using age file encryption";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
