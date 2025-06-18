{
  lib,
  stdenv,
  fetchFromGitHub,
  mono,
}:
stdenv.mkDerivation {
  pname = "convchain";
  version = "0.0pre20160901";
  src = fetchFromGitHub {
    owner = "mxgmn";
    repo = "ConvChain";
    rev = "8abb1e88a496fcae4c0ae31acd4eea55957dab68";
    sha256 = "0lnscljgbw0s90sfcahwvnxakml0f4d8jxi5ikm4ak8qgnvw6rql";
  };
  buildPhase = ''
    mcs ConvChain.cs -out:convchain.exe -r:System.Drawing
    mcs ConvChainFast.cs -out:convchainfast.exe -r:System.Drawing
    grep -m1 -B999 '^[*][/]' ConvChainFast.cs > COPYING.MIT
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/convchain,share/convchain}
    cp README.md COPYING.MIT "$out"/share/doc/convchain
    cp convchain*.exe "$out"/bin
    cp -r [Ss]amples samples.xml "$out/share/convchain"

    echo "#! ${stdenv.shell}" >> "$out/bin/convchain"
    echo "chmod u+w ." >> "$out/bin/convchain"
    echo "'${mono}/bin/mono' '$out/bin/convchain.exe' \"\$@\"" >>  "$out/bin/convchain"
    chmod a+x "$out/bin/convchain"

    echo "#! ${stdenv.shell}" >> "$out/bin/convchainfast"
    echo "chmod u+w ." >> "$out/bin/convchainfast"
    echo "'${mono}/bin/mono' '$out/bin/convchainfast.exe' \"\$@\"" >>  "$out/bin/convchainfast"
    chmod a+x "$out/bin/convchainfast"
  '';
  buildInputs = [ mono ];
  meta = {
    description = "Bitmap generation from a single example with convolutions and MCMC";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
