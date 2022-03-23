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
    sha256 = "e628aeddb94d2470de860df09ef65499f8c5493fb336bf3df8502842ee02487f";
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

  vendorSha256 = "214dc073dad7b323ea449acf24c5b578d573432eeaa1506cf5761a2d7f5ce405";

  nativeBuildInputs = [ pandoc installShellFiles makeWrapper ];
  checkInputs = [ bash coreutils git ];
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
