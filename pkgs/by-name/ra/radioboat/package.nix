{ lib
, fetchFromGitHub
, buildGoModule
, mpv
, makeWrapper
, installShellFiles
, nix-update-script
, testers
, radioboat
}:

buildGoModule rec {
  pname = "radioboat";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    rev = "v${version}";
    hash = "sha256-4k+WK2Cxu1yBWgvEW9LMD2RGfiY7XDAe0qqph82zvlI=";
  };

  vendorHash = "sha256-H2vo5gngXUcrem25tqz/1MhOgpNZcN+IcaQHZrGyjW8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slashformotion/radioboat/internal/buildinfo.Version=${version}"
  ];

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  preFixup = ''
    wrapProgram $out/bin/radioboat --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  '';

  postInstall = ''
    installShellCompletion --cmd radioboat \
      --bash <($out/bin/radioboat completion bash) \
      --fish <($out/bin/radioboat completion fish) \
      --zsh <($out/bin/radioboat completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = radioboat;
      command = "radioboat version";
    };
  };

  meta = with lib; {
    description = "Terminal web radio client";
    mainProgram = "radioboat";
    homepage = "https://github.com/slashformotion/radioboat";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
