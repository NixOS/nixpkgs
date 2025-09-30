{
  buildGoModule,
  fetchFromGitea,
  lib,
  jq,
  installShellFiles,
  makeBinaryWrapper,
  scdoc,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ijq";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gpanders";
    repo = "ijq";
    rev = "v${version}";
    hash = "sha256-PT7WnCZL4Cfo/+VW3ImOloDOI9d0GX4UTcC8Bf3OVAU=";
  };

  vendorHash = "sha256-1R3rv3FraT53dqGECRr+ulhplmmByqRW+VJ+y6nFR+Y=";

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
    homepage = "https://codeberg.org/gpanders/ijq";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      justinas
      mattpolzin
      SuperSandro2000
    ];
  };
}
