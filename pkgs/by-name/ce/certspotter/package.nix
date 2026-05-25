{
  lib,
  fetchFromGitHub,
  buildGoModule,
  lowdown-unsandboxed,
}:

buildGoModule (finalAttrs: {
  pname = "certspotter";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "SSLMate";
    repo = "certspotter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OmukbtHOvyfjRb7WdAc3A3I5FlWmQD515dNeJ5JiJ0k=";
  };

  vendorHash = "sha256-F7qNpvjWqywPPLTKw90bfy6V83/LMQcV+Gml2n1Wd2A=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Source=software.sslmate.com/src/certspotter"
  ];

  checkFlags = [
    "-skip=TestParseFromURL" # requires network access
  ];

  nativeBuildInputs = [ lowdown-unsandboxed ];

  postInstall = ''
    cd man
    make
    mkdir -p $out/share/man/man8
    mv *.8 $out/share/man/man8
  '';

  meta = {
    description = "Certificate Transparency Log Monitor";
    homepage = "https://github.com/SSLMate/certspotter";
    changelog = "https://github.com/SSLMate/certspotter/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "certspotter";
    maintainers = with lib.maintainers; [ chayleaf ];
  };
})
