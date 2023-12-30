{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "neonmodem";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "neonmodem";
    rev = "v${version}";
    hash = "sha256-gc3uPck+2ecqpRtnkvjlTX6H4Dsvn4iynhZEJsNO1bo=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-EGltrOKPHpgRNYspIv7LuGJ6SvCtp7TGap/DBa8yHZg=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/mrusme/neonmodem/config.VERSION=v${version}"
  ];

  postInstall = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.cache
    touch $HOME/.cache/neonmodem.log # must create this file or neonmodem will not generate completitions
    installShellCompletion --cmd neonmodem \
      --bash <($out/bin/neonmodem completion bash) \
      --fish <($out/bin/neonmodem completion fish) \
      --zsh <($out/bin/neonmodem completion zsh)
  '';

  meta = with lib; {
    description = "Neon Modem Overdrive";
    homepage = "https://neonmodem.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ltstf1re ];
  };
}
