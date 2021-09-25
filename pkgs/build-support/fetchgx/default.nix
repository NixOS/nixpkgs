{ stdenvNoCC, gx, gx-go, go, cacert }:

{ name, src, sha256 }:

stdenvNoCC.mkDerivation {
  name = "${name}-gxdeps";
  inherit src;

  nativeBuildInputs = [ cacert go gx gx-go ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  dontConfigure = true;
  doCheck = false;
  doInstallCheck = false;

  buildPhase = ''
    export GOPATH=$(pwd)/vendor
    mkdir -p vendor
    gx install
  '';

  installPhase = ''
    mv vendor $out
  '';

  preferLocalBuild = true;
}
