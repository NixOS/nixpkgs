{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  bash,
  coreutils,
  git,
  pandoc,
}:

let
  version = "1.3.1";
  commit = "b6be8bac78605c21a9670db0e44faf5e1eafe0d4";
in
buildGoModule {
  pname = "gg-scm";
  inherit version;

  src = fetchFromGitHub {
    owner = "gg-scm";
    repo = "gg";
    rev = "v${version}";
    hash = "sha256-qw0KWhCkJVYRhDBNtiNactWGGMHjBwdQ1Po4lQQbaj4=";
  };
  postPatch = ''
    substituteInPlace cmd/gg/editor_unix.go \
      --replace /bin/sh ${bash}/bin/sh
  '';
  subPackages = [ "cmd/gg" ];
  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.versionInfo=${version}"
    "-X"
    "main.buildCommit=${commit}"
  ];

  vendorHash = "sha256-56Sah030xbWsoOu8r3c3nN2UGHvQORheavebP+Z1Wc8=";

  nativeBuildInputs = [
    pandoc
    installShellFiles
    makeWrapper
  ];
  nativeCheckInputs = [
    bash
    coreutils
    git
  ];
  buildInputs = [
    bash
    git
  ];

  postInstall = ''
    wrapProgram $out/bin/gg --suffix PATH : ${git}/bin
    pandoc --standalone --to man misc/gg.1.md -o misc/gg.1
    installManPage misc/gg.1
    installShellCompletion --cmd gg \
      --bash misc/gg.bash \
      --zsh misc/_gg.zsh
  '';

  meta = {
    mainProgram = "gg";
    description = "Git with less typing";
    longDescription = ''
      gg is an alternative command-line interface for Git heavily inspired by Mercurial.
      It's designed for less typing in common workflows,
      making Git easier to use for both novices and advanced users alike.
    '';
    homepage = "https://gg-scm.io/";
    changelog = "https://github.com/gg-scm/gg/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
}
