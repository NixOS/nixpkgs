{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  makeBinaryWrapper,
}:

bundlerApp {
  pname = "cddl";

  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;

  gemset = lib.recursiveUpdate (import ./gemset.nix) {
    "cddl" = {
      dontBuild = false;
      # setting env vars is not supported by patchShebangs
      postPatch = ''
        sed -i 's\#!/usr/bin/env RUBY_THREAD_VM_STACK_SIZE=5000000\#!/usr/bin/env\' bin/cddl
      '';
    };
  };

  exes = [ "cddl" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/cddl \
      --set RUBY_THREAD_VM_STACK_SIZE 5000000
  '';

  passthru.updateScript = bundlerUpdateScript "cddl";

  meta = with lib; {
    description = "Parser, generator, and validator for CDDL";
    homepage = "https://rubygems.org/gems/cddl";
    license = with licenses; mit;
    maintainers = with maintainers; [
      fdns
      nicknovitski
      amesgen
    ];
    platforms = platforms.unix;
  };
}
