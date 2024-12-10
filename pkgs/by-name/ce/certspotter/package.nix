{
  lib,
  fetchFromGitHub,
  buildGoModule,
  lowdown,
}:

buildGoModule rec {
  pname = "certspotter";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "SSLMate";
    repo = "certspotter";
    rev = "v${version}";
    hash = "sha256-nyeqpDMRZRuHjfl3cI/I00KpVg3udjr0B8MEBZcF7nY=";
  };

  vendorHash = "sha256-6dV9FoPV8UfS0z5RuuopE99fHcT3RAWCdDi7jpHzVRE=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ lowdown ];

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
