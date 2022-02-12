{ pname, version, src, meta, stdenv, binaryName, desktopName, undmg }:

stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r "${desktopName}.app" $out/Applications
  '';
}
