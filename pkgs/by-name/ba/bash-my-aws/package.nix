{
  lib,
  stdenv,
  makeWrapper,
  awscli2,
  jq,
  unixtools,
  fetchFromGitHub,
  installShellFiles,
  bashInteractive,
  getopt,
  python3,
}:
let
  runtimeDeps = [
    awscli2
    jq
    unixtools.column
    bashInteractive
    getopt
    (python3.withPackages (ps: [ ps.jmespath ]))
  ];
in
stdenv.mkDerivation {
  pname = "bash-my-aws";
  version = "0-unstable-2025-01-22";

  src = fetchFromGitHub {
    owner = "bash-my-aws";
    repo = "bash-my-aws";
    rev = "d338b43cc215719c1853ec500c946db6b9caaa11";
    sha256 = "sha256-PR52T6XCrakQsBOJXf0PaYpYE5oMcIz5UDA4I9B7C38=";
  };

  dontConfigure = true;

  propagatedBuildInputs = runtimeDeps;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
    bashInteractive
  ];

  patches = [
    ./0001-update-paths-to-placeholders.patch
    ./0002-fix-tests.patch
  ];

  postPatch = ''
    patchShebangs --build ./scripts

    substituteAllInPlace ./scripts/build
    substituteAllInPlace ./scripts/build-completions
    substituteAllInPlace ./bin/bma
  '';

  buildPhase = ''
    runHook preBuild
    ./scripts/build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out

    cat > $out/bin/bma-init <<EOF
    echo source $out/aliases
    EOF
    chmod +x $out/bin/bma-init

    installShellCompletion --bash --name bash-my-aws.bash $out/bash_completion.sh

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    pushd $out
    make test
    popd
    runHook postInstallCheck
  '';

  preFixup = ''
    wrapProgram $out/bin/bma --prefix PATH : ${lib.makeBinPath runtimeDeps}

    # make lib file executable so they are picked up by patchShebangs
    chmod +x $out/lib/*
  '';

  meta = with lib; {
    homepage = "https://bash-my-aws.org";
    description = "CLI commands for AWS";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
    mainProgram = "bma";
  };
}
