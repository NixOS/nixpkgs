<<<<<<< HEAD
{ stdenv
, lib
, pkgs
, bundlerEnv
, bundlerApp
, bundlerUpdateScript
, installShellFiles
}:

let
  ttBundlerApp = bundlerApp {
    pname = "timetrap";
    gemdir = ./.;
    exes = [ "t" "timetrap" ];

    passthru.updateScript = bundlerUpdateScript "timetrap";
  };

  ttGem = bundlerEnv {
    pname = "timetrap";
    gemdir = ./.;
  };

in

stdenv.mkDerivation {
  name = "timetrap";

  dontUnpack = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir $out;
    cd $out;

    mkdir bin; pushd bin;
    ln -vs ${ttBundlerApp}/bin/t;
    ln -vs ${ttBundlerApp}/bin/timetrap;
    popd;

    for c in t timetrap; do
      installShellCompletion --cmd $c --bash ${ttGem}/lib/ruby/gems/*/gems/timetrap*/completions/bash/*;
      installShellCompletion --cmd $c --zsh ${ttGem}/lib/ruby/gems/*/gems/timetrap*/completions/zsh/*;
    done;
  '';
=======
{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "timetrap";
  gemdir = ./.;
  exes = [ "t" "timetrap" ];

  passthru.updateScript = bundlerUpdateScript "timetrap";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A simple command line time tracker written in ruby";
    homepage    = "https://github.com/samg/timetrap";
    license     = licenses.mit;
    maintainers = with maintainers; [ jerith666 manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}
