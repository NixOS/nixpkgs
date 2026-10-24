{
  buildGoModule,
  fetchFromCodeberg,
  lib,
  jq,
  installShellFiles,
  makeBinaryWrapper,
  scdoc,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ijq";
  version = "1.4.2";

  src = fetchFromCodeberg {
    owner = "gpanders";
    repo = "ijq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qvT8iREi8bi5T5/Ixli961cSNdymUe4z7xW7evng7sQ=";
  };

  vendorHash = "sha256-aU/0CIbI49OwgY6ioT50uPxld/rHAve3+KoILgPpWSQ=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    scdoc
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
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

  meta = {
    description = "Interactive wrapper for jq";
    mainProgram = "ijq";
    homepage = "https://codeberg.org/gpanders/ijq";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      justinas
      mattpolzin
      SuperSandro2000
    ];
  };
})
