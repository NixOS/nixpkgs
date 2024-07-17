{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-md2man,
  installShellFiles,
  bash,
}:

buildGoModule rec {
  pname = "umoci";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "umoci";
    rev = "v${version}";
    sha256 = "0in8kyi4jprvbm3zsl3risbjj8b0ma62yl3rq8rcvcgypx0mn7d4";
  };

  vendorHash = null;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  postInstall = ''
    make docs SHELL="$SHELL"
    installManPage doc/man/*.[1-9]
  '';

  meta = with lib; {
    description = "umoci modifies Open Container images";
    homepage = "https://umo.ci";
    license = licenses.asl20;
    maintainers = with maintainers; [ zokrezyl ];
    mainProgram = "umoci";
  };
}
