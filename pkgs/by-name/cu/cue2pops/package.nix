{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "cue2pops";
  version = "0-unstable-2018-01-04";

  src = fetchFromGitHub {
    owner = "makefu";
    repo = "cue2pops-linux";
    rev = "541863adf23fdecde92eba5899f8d58586ca4551";
    hash = "sha256-M1u/UqS2nONovLTr5KFlBPbzztlpcQ5+HmOOZ8QhiBc=";
  };

  dontConfigure = true;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall
    install --directory --mode=755 $out/bin
    install --mode=755 cue2pops $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Convert CUE to ISO suitable to POPStarter";
    homepage = "https://github.com/makefu/cue2pops-linux";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
    mainProgram = "cue2pops";
  };
}
