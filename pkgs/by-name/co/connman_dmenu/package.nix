{
  lib,
  stdenv,
  fetchFromGitHub,
  connman,
  dmenu,
}:

stdenv.mkDerivation {
  pname = "connman_dmenu";
  version = "unstable-2015-09-29";

  src = fetchFromGitHub {
    owner = "march-linux";
    repo = "connman_dmenu";
    rev = "cc89fec40b574b0d234afeb70ea3c94626ca3f5c";
    sha256 = "061fi83pai4n19l9d7wq6wwj2d7cixwkhkh742c5ibmw1wb274yk";
  };

  buildInputs = [
    connman
    dmenu
  ];

  dontBuild = true;

  # remove root requirement, see: https://github.com/march-linux/connman_dmenu/issues/3
  postPatch = ''
    sed -i '89,92d' connman_dmenu
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp connman_dmenu $out/bin/
  '';

  meta = {
    description = "Dmenu wrapper for connmann";
    mainProgram = "connman_dmenu";
    homepage = "https://github.com/march-linux/connman_dmenu";
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
  };
}
