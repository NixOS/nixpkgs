{ stdenv
, fetchFromGitHub
, dcm2niix
, python
, name
, src
}:

stdenv.mkDerivation {
  inherit name src;

  nativeBuildInputs = [ dcm2niix python ];

  dontConfigure = true;
  dontBuild = true;
  doCheck = true;
  dontFixup = true;

  patchPhase = ''
    patchShebangs batch.sh
  '';

  checkPhase = ''
    ./batch.sh
  '';

  installPhase = ''
    touch "$out"
  '';

  meta.timeout = 120;
}
