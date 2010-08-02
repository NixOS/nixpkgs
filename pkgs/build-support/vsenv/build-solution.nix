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
    ensureDir $out
    cp Debug/* $out
  '';
  buildInputs = [ vs ] ++ extraBuildInputs;
}
