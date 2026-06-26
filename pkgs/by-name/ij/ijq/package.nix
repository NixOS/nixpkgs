{
  buildGo126Module,
  fetchFromCodeberg,
  lib,
  jq,
  installShellFiles,
  makeBinaryWrapper,
  scdoc,
  nix-update-script,
}:

buildGo126Module (finalAttrs: {
  pname = "ijq";
  version = "1.3.0";

  src = fetchFromCodeberg {
    owner = "gpanders";
    repo = "ijq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U4UKhWI/xd7+rLa350oIFlCqbiMSZe3ztPFR0uierOo=";
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
