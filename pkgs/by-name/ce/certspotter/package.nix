{
  lib,
  fetchFromGitHub,
  buildGoModule,
  lowdown-unsandboxed,
}:

buildGoModule rec {
  pname = "certspotter";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "SSLMate";
    repo = "certspotter";
    rev = "v${version}";
    hash = "sha256-aVlCN2bk/gKUb6gQ7/VnhJCx1x5A9UzOzg/WA9VxBVY=";
  };

  vendorHash = "sha256-+6Gu3y708XXX7CHvZmEh7j3ILNBi/++8Mud34mOrtmA=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ lowdown-unsandboxed ];

  postInstall = ''
    cd man
    make
    mkdir -p $out/share/man/man8
    mv *.8 $out/share/man/man8
  '';

  meta = with lib; {
    description = "Certificate Transparency Log Monitor";
    homepage = "https://github.com/SSLMate/certspotter";
    changelog = "https://github.com/SSLMate/certspotter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    mainProgram = "certspotter";
    maintainers = with maintainers; [ chayleaf ];
  };
}
