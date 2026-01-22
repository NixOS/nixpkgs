{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "collapseos-cvm";
  version = "20220316";
  src = fetchurl {
    url = "http://collapseos.org/files/collapseos-${version}.tar.gz";
    hash = "sha256-8bt6wj93T82K9fqtuC/mctkMCzfvW0taxv6QAKeJb5g=";
  };
  buildInputs = [ ncurses ];
  sourceRoot = "cvm";
  postPatch = ''
    substituteInPlace common.mk \
      --replace "-lcurses" "-lncurses"
  '';
  installPhase = ''
    runHook preInstall;
    find . -type f -executable -exec install -Dt $out/bin {} \;
    runHook postInstall;
  '';
  meta = {
    description = "Virtual machine for Collapse OS (Forth operating system)";
    changelog = "http://collapseos.org/files/CHANGES.txt";
    downloadPage = "http://collapseos.org/files/";
    homepage = "http://collapseos.org/";
    license = lib.licenses.gpl3Only;
    mainProgram = "cos-serial";
  };
}
