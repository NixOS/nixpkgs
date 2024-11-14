{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "pet";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "sha256-h6e7X93uU/rdTrCz5xJcNtpDbzcF/2Z186b4dHkp9jM=";
  };

  vendorHash = "sha256-hf2I5xHloqcXDlC8frxtCiQx2PlTmKmyd1mrzF2UdDo=";

  ldflags = [
    "-s" "-w" "-X=github.com/knqyf263/pet/cmd.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd pet \
      --zsh ./misc/completions/zsh/_pet
  '';

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    mainProgram = "pet";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
