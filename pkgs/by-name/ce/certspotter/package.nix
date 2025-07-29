{
  lib,
  fetchFromGitHub,
  buildGoModule,
  lowdown-unsandboxed,
}:

buildGoModule rec {
  pname = "certspotter";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "SSLMate";
    repo = "certspotter";
    rev = "v${version}";
    hash = "sha256-cJIjJyWvy/prx97jUvVToJsEdMa0MpqATD9rO8G2biY=";
  };

  vendorHash = "sha256-CLq/QFnZ5OLv7wT+VYr5SkSgmwt1g6cBYcAlB4Z/3wE=";

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
