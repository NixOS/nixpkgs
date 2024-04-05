{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "gnmic";
  version = "0.36.2";

  src = fetchFromGitHub {
    owner = "openconfig";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PUOIKPkzM6riiXR8R1Io0QI/qr6HaexfFgbp2Hx2SOo=";
  };

  vendorHash = "sha256-zrG/rNoYtfVNN50g41txLQIcBAKi1yE5p1TODrDiXzU=";

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
    mainProgram = "gnmic";
  };
}
