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
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    rev = "v${version}";
    sha256 = "sha256-nY8h09SDTQPKLAHgWr3q8yRGtw3bIWvAFVu05rqXPcg=";
  };

  vendorSha256 = "sha256-76Q77BXNe6NGxn6ocYuj58M4aPGCWTekKV5tOyxBv2U=";

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
      version = version;
    };
  };

  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/slashformotion/radioboat";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
