{
  stdenv,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
  patch,
}:

{
  rev,
  hash,
}:

stdenv.mkDerivation {
  pname = "hardened-chromium";

  version = rev;

  src = fetchFromGitHub {
    owner = "secureblue";
    repo = "hardened-chromium";
    inherit rev hash;
  };

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir $out
    cp -R *patches $out/
  '';
}
