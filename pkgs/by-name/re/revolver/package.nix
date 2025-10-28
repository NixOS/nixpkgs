{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  zsh,
  installShellFiles,
  ncurses,
  unstableGitUpdater,
  testers,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "revolver";
  version = "0.2.4-unstable-2020-09-30";

  src = fetchFromGitHub {
    owner = "molovo";
    repo = "revolver";
    rev = "6424e6cb14da38dc5d7760573eb6ecb2438e9661";
    hash = "sha256-2onqjtPIsgiEJj00oP5xXGkPZGQpGPVwcBOhmicqKcs=";
  };

  strictDeps = true;
  doInstallCheck = true;

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [
    zsh
    ncurses
  ];
  nativeInstallCheckInputs = [ zsh ];

  patches = [ ./no-external-call.patch ];

  postPatch = ''
    substituteInPlace revolver \
      --replace-fail "tput cols" "${ncurses}/bin/tput cols"
  '';

  installPhase = ''
    runHook preInstall

    install -D revolver $out/bin/revolver

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd revolver --zsh revolver.zsh-completion
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    PATH=$PATH:$out/bin revolver --help

    runHook postInstallCheck
  '';

  passthru = {
    tests = {
      demo = runCommand "revolver-demo" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
        export HOME="$TEMPDIR"

        # Drop stdout, redirect stderr to stdout and check if it's not empty
        exec 9>&1
        echo "Running revolver demo..."
        if [[ $(revolver demo 2>&1 1>/dev/null | tee >(cat - >&9)) ]]; then
          exit 1
        fi
        echo "Demo done!"

        mkdir $out
      '';
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        # Wrong '0.2.0' version in the code
        version = "0.2.0";
      };
    };
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  meta = {
    description = "Progress spinner for ZSH scripts";
    homepage = "https://github.com/molovo/revolver";
    downloadPage = "https://github.com/molovo/revolver/releases";
    license = lib.licenses.mit;
    mainProgram = "revolver";
    inherit (zsh.meta) platforms;
    maintainers = with lib.maintainers; [ d-brasher ];
  };
})
