{
  lib,
  bash,
  gawk,
  which,
  gnused,
  gnugrep,
  ncurses,
  coreutils,
  unixtools,
  resholve,
  stdenvNoCC,
  fetchpatch2,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation {
  pname = "kanban.bash";
  version = "0-unstable-2024-10-17";
  src = fetchFromGitHub {
    owner = "coderofsalvation";
    repo = "kanban.bash";
    rev = "325e2c0c3e75f6bb2106d15107559bc1eea6fd5d";
    hash = "sha256-OE4kKixNG172yMR5vp5O4STq9fGdJVWLIt7j6deNxhI=";
  };
  patches = [
    # bug fix for linux
    (fetchpatch2 {
      url = "https://github.com/coderofsalvation/kanban.bash/pull/45.patch?full_index=1";
      hash = "sha256-di71KpkdJ7x58W6Yw5y1VXHbdLUUXUcr+V4Cu5JP+eg=";
    })
  ];
  nativeBuildInputs = [ installShellFiles ];
  buildPhase = ''
    runHook preBuild
    mkdir -p $out/bin
    mv kanban $out/bin
    exe=$out/bin/kanban
    # remove deps check and replace stray tput in a string
    substituteInPlace $exe \
      --replace-fail "$(grep "deps=" $exe)" "" \
      --replace-fail "$(grep "for dep in" $exe)" "" \
      --replace-fail "tput sgr0" "${ncurses}/bin/tput sgr0"
    ${resholve.phraseSolution "kanban" {
      scripts = [ "bin/kanban" ];
      interpreter = "${bash}/bin/bash";
      keep = {
        "$EDITOR" = true;
        source = [ "$FILE_CONF" ];
      };
      inputs = [
        which
        gawk
        gnused
        gnugrep
        ncurses # tput
        unixtools.column
        unixtools.locale
        unixtools.more
        coreutils
      ];
    }}
    installShellCompletion --cmd kanban \
      --name kanban.bash --bash kanban.completion
    runHook postBuild
  '';

  # from .travis.yml, the complete test suite
  installCheckPhase = ''
    runHook preInstallCheck
    (
      cd test
      export PLAIN=1 NOCOLOR=1 EDITOR=vi
      cp $out/bin/kanban $TMP/kanban
      remove="| "${unixtools.more}/bin/more
      substituteInPlace $TMP/kanban --replace-fail "$remove" ""
      for test in test-*; do
        substituteInPlace $test \
          --replace-quiet '../../kanban' $TMP/kanban \
          --replace-fail '../kanban' $TMP/kanban
        echo $test && bash ./$test &>/dev/null
      done
    )
    runHook postInstallCheck
  '';
  nativeInstallCheckInputs = [ writableTmpDirAsHomeHook ];
  doInstallCheck = true;

  meta = {
    description = "Commandline ascii kanban board for minimalist productivity hackers";
    homepage = "https://github.com/coderofsalvation/kanban.bash";
    mainProgram = "kanban";
    maintainers = with lib.maintainers; [
      coderofsalvation
      phanirithvij
    ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
  };
}
