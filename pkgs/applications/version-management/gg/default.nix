{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, bash
, coreutils
, git
, pandoc
}:

let
  version = "1.3.0";
  commit = "5bfe79b3632f15c442e8dc51ec206ab76354487f";
in buildGoModule {
  pname = "gg-scm";
  inherit version;

  src = fetchFromGitHub {
    owner = "gg-scm";
    repo = "gg";
    rev = "v${version}";
    hash = "sha256-5iiu3blNJHDehg3wnvZUmfjFST+zNr89+FAoQu4CSH8=";
  };
  postPatch = ''
    substituteInPlace cmd/gg/editor_unix.go \
      --replace /bin/sh ${bash}/bin/sh
  '';
  subPackages = [ "cmd/gg" ];
  ldflags = [
    "-s" "-w"
    "-X" "main.versionInfo=${version}"
    "-X" "main.buildCommit=${commit}"
  ];

  vendorHash = "sha256-IU3Ac9rXsyPqRJrPJMW1eNVzQy7qoVBs9XYaLX9c5AU=";

  nativeBuildInputs = [ pandoc installShellFiles makeWrapper ];
  nativeCheckInputs = [ bash coreutils git ];
  buildInputs = [ bash git ];

  postInstall = ''
    wrapProgram $out/bin/gg --suffix PATH : ${git}/bin
    pandoc --standalone --to man misc/gg.1.md -o misc/gg.1
    installManPage misc/gg.1
    installShellCompletion --cmd gg \
      --bash misc/gg.bash \
      --zsh misc/_gg.zsh
  '';

  meta = with lib; {
    mainProgram = "gg";
    description = "Git with less typing";
    longDescription = ''
      gg is an alternative command-line interface for Git heavily inspired by Mercurial.
      It's designed for less typing in common workflows,
      making Git easier to use for both novices and advanced users alike.
    '';
    homepage = "https://gg-scm.io/";
    changelog = "https://github.com/gg-scm/gg/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ zombiezen ];
  };
}
