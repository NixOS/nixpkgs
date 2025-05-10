{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "cue2pops";
  version = "0-unstable-2023-01-15";

  src = fetchFromGitHub {
    owner = "makefu";
    repo = "cue2pops-linux";
    rev = "3f2be6126bd50dfe6b998bc8926f88ce9139c19a";
    hash = "sha256-7rgYvqeH8ZDI8Vc5vnjIhe3Ke0TE1q/iFHEqucanhUM=";
  };

  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install --directory --mode=755 $out/bin
    install --mode=755 cue2pops $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Convert CUE to ISO suitable to POPStarter";
    homepage = "https://github.com/makefu/cue2pops-linux";
    # Upstream license is unclear.
    # <https://github.com/ErikAndren/cue2pops-mac/issues/2#issuecomment-673983298>
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
    mainProgram = "cue2pops";
  };
}
