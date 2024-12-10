{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  ffmpeg,
  ttyd,
  chromium,
  makeWrapper,
}:

buildGoModule rec {
  pname = "vhs";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CWurSAxEXAquWXEOyBWBF6JN9Pesm5hBS3jVNv56dvE=";
  };

  vendorHash = "sha256-Kh5Sy7URmhsyBF35I0TaDdpSLD96MnkwIS+96+tSyO0=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/vhs --prefix PATH : ${
      lib.makeBinPath (
        lib.optionals stdenv.isLinux [ chromium ]
        ++ [
          ffmpeg
          ttyd
        ]
      )
    }
    $out/bin/vhs man > vhs.1
    installManPage vhs.1
    installShellCompletion --cmd vhs \
      --bash <($out/bin/vhs completion bash) \
      --fish <($out/bin/vhs completion fish) \
      --zsh <($out/bin/vhs completion zsh)
  '';

  meta = with lib; {
    description = "A tool for generating terminal GIFs with code";
    mainProgram = "vhs";
    homepage = "https://github.com/charmbracelet/vhs";
    changelog = "https://github.com/charmbracelet/vhs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      maaslalani
      penguwin
    ];
  };
}
