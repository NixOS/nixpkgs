{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "gnmic";
  version = "0.31.3";

  src = fetchFromGitHub {
    owner = "openconfig";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+TxOl+at/SQIC1x/LwCgk4JmvOPY2el7HE1reAkmVn8=";
  };

  vendorHash = "sha256-4cmFoDMgD9TKacZ2RD73kQKDrpN5xuSKZ4ikcWAd5Rw=";

  ldflags = [
    "-s" "-w"
    "-X" "github.com/openconfig/gnmic/app.version=${version}"
    "-X" "github.com/openconfig/gnmic/app.commit=${src.rev}"
    "-X" "github.com/openconfig/gnmic/app.date=1970-01-01T00:00:00Z"
  ];
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
    installShellCompletion --cmd gnmic \
      --bash <(${emulator} $out/bin/gnmic completion bash) \
      --fish <(${emulator} $out/bin/gnmic completion fish) \
      --zsh  <(${emulator} $out/bin/gnmic completion zsh)
  '';

  meta = with lib; {
    description = "gNMI CLI client and collector";
    homepage = "https://gnmic.openconfig.net/";
    changelog = "https://github.com/openconfig/gnmic/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ vincentbernat ];
  };
}
