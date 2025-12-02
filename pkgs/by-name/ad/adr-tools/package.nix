{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nix-update-script,

  bash,
  bashInteractive,
  coreutils,
  findutils,
  gawk,
  getopt,
  gnugrep,
  gnused,

  # tests
  adr-tools,
  runCommand,
}:

stdenv.mkDerivation rec {
  pname = "adr-tools";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "npryce";
    repo = "adr-tools";
    tag = version;
    hash = "sha256-JEwLn+SY6XcaQ9VhN8ARQaZc1zolgAJKfIqPggzV+sU=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    # need an interactive interpreter for compgen
    bashInteractive
  ];

  checkInputs = [ getopt ];

  dontConfigure = true;
  dontBuild = true;
  doCheck = true;

  # patch makefile and shebangs so checks can run
  patchPhase = ''
    substituteInPlace Makefile --replace-fail '/bin:/usr/bin' '$${HOST_PATH}'
    patchShebangs src/
    patchShebangs approve
  '';

  checkPhase = ''
    make check
  '';

  installPhase = ''
    mkdir -p $out/bin/ $out/libexec
    cp src/* $out/libexec

    makeWrapper $out/libexec/adr $out/bin/adr --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        findutils
        gawk
        getopt
        gnugrep
        gnused
      ]
    }
    installShellCompletion --bash autocomplete/adr
  '';

  passthru = {
    tests.default = runCommand "adr-tools-test" { } ''
      set -euo pipefail
      export PATH=$PATH:${
        lib.makeBinPath [
          adr-tools
          gnugrep
        ]
      }

      mkdir $out
      cd $out

      adr init
      test -e doc/adr/0001-record-architecture-decisions.md

      EDITOR= adr new blah
      test -e doc/adr/0002-blah.md

      adr generate toc | grep 0002-blah.md
      adr list | grep 0002-blah.md

      adr link 2 Amends 1 "TESTED AMEND"
      grep 'TESTED AMEND' doc/adr/0001-record-architecture-decisions.md | grep 0002-blah.md
    '';

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command-line tools for working with Architecture Decision Records";
    homepage = "https://github.com/npryce/adr-tools";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "adr";
    platforms = lib.platforms.all;
  };
}
