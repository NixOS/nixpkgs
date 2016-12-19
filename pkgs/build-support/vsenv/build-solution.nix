{stdenv, vs}:
{ name
, src
, slnFile
, baseDir ? "."
, extraBuildInputs ? []
}:

stdenv.mkDerivation {
  inherit name src;
  installPhase = ''
    cd ${baseDir}
    vcbuild.exe /rebuild ${slnFile}
    mkdir -p $out
    cp Debug/* $out
  '';
  buildInputs = [ vs ] ++ extraBuildInputs;
}
