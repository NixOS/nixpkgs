{ lib
, stdenvNoCC
, bundlerApp
}:

let
  bashlyBundlerApp = bundlerApp {
    pname = "bashly";
    gemdir = ./.;
    exes = [ "bashly" ];
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "bashly";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out;
    cd $out;

    mkdir bin; pushd bin;
    ln -vs ${bashlyBundlerApp}/bin/bashly;

    runHook postInstall
  '';

  meta = {
    description = "Bash command line framework and CLI generator";
    homepage = "https://github.com/DannyBen/bashly";
    license = lib.licenses.mit;
    mainProgram = "bashly";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.unix;
  };
})
