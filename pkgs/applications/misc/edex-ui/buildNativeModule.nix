{ stdenv, fetchurl, fetchNodeModules, python2, electron, nodePackages }:
{ name, src, nodejs, sha256, headerSHA256 }:

let
  plat = {
    "i686-linux" = "ia32";
    "x86_64-linux" = "x64";
  }.${stdenv.hostPlatform.system};

  headers = fetchurl {
    url = "https://atom.io/download/electron/v${electron.version}/iojs-v${electron.version}.tar.gz";
    sha256 = headerSHA256;
  };
in stdenv.mkDerivation rec {
  inherit src name;

  node_modules = fetchNodeModules {
    inherit src nodejs sha256;
  };

  configurePhase = ''
    cp -r ${node_modules} node_modules
  '';

  nativeBuildInputs = [
    nodejs
    python2
    nodePackages.node-gyp
  ];

  buildPhase = ''
    HOME=. node-gyp rebuild \
      --arch=${plat} \
      --target=${electron.version} \
      --tarball=${headers}
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';
}
