{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "ets";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "gdubicki";
    repo = "ets";
    rev = "v${version}";
    hash = "sha256-LnNd4rAMJliWKbL4uVl11BAa9FPUcLwVSWnFe1vEk7g=";
  };

  vendorHash = "sha256-lzukgI/7gxlWHY81MkK1CzpUUaZ4B+4xZ0RSZUpL62c=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}-nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    rm -rf fixtures
  '';

  postInstall = ''
    installManPage ets.1
  '';

  doCheck = false;

  meta = with lib; {
    description = "Command output timestamper";
    homepage = "https://github.com/gdubicki/ets/";
    license = licenses.mit;
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "ets";
  };
}
