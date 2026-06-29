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
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "kanban.bash";
  version = "0-unstable-2025-09-16";
  src = fetchFromGitHub {
    owner = "coderofsalvation";
    repo = "kanban.bash";
    rev = "b0b6563c109ae12b94bfe4441eeb5e8ce1c8b5ce";
    hash = "sha256-5uwLm5L40YrCCGIXfRLJTS2GpSuXMEJeEnd2aVbnbo4=";
  };
  patches = [
    # remove references to sed -i '' and use gnused on macos
    ./fix-sed-i.patch
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

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
