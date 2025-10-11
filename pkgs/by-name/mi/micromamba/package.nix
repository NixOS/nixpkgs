{
  lib,
  stdenv,
  mamba-cpp,
}:

stdenv.mkDerivation {
  pname = "micromamba";
  version = mamba-cpp.version;

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${mamba-cpp}/bin/mamba $out/bin/micromamba
  '';

  meta = mamba-cpp.meta // {
    maintainers = with lib.maintainers; [ mausch ];
    mainProgram = "micromamba";
  };

}
