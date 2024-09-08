{
  buildGoModule,
  fetchFromSourcehut,
  lib,
  jq,
  installShellFiles,
  makeBinaryWrapper,
  scdoc,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ijq";
  version = "1.1.2";

  src = fetchFromSourcehut {
    owner = "~gpanders";
    repo = "ijq";
    rev = "v${version}";
    hash = "sha256-7vG9T+gC6HeSGwFDf3m7nM0hBz32n6ATiM30AKNC1Og=";
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

  passthru.updateScript = nix-update-script { };

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
