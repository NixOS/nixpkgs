{
  buildGoModule,
  fetchFromSourcehut,
  lib,
  jq,
  installShellFiles,
  makeBinaryWrapper,
  scdoc,
}:

buildGoModule rec {
  pname = "ijq";
  version = "1.1.1";

  src = fetchFromSourcehut {
    owner = "~gpanders";
    repo = "ijq";
    rev = "v${version}";
    hash = "sha256-rnSpXMadZW6I+7tIYqr1Cb4z00gdREsqin/r6OXaDMA=";
  };

  vendorHash = "sha256-zRa8MPWFvcoVm+LstbSAl1VY3oWMujZPjWS/ti1VXjE=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    scdoc
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postBuild = ''
    scdoc < ijq.1.scd > ijq.1
    installManPage ijq.1
  '';

  postInstall = ''
    wrapProgram "$out/bin/ijq" \
      --prefix PATH : "${lib.makeBinPath [ jq ]}"
  '';

  meta = with lib; {
    description = "Interactive wrapper for jq";
    mainProgram = "ijq";
    homepage = "https://git.sr.ht/~gpanders/ijq";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      justinas
      mattpolzin
      SuperSandro2000
    ];
  };
}
