{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nix,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "niks3";
  version = "1.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "niks3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5uAELLs24viJQllCa6xIkvzJUTP0ySOAz5JJrXkkHfM=";
  };

  vendorHash = "sha256-dAarYako0R2CQG+t03jSSpWPkP5vCFpyrMssTGKOQn0=";

  subPackages = [
    "cmd/niks3"
    "cmd/niks3-hook"
    "cmd/niks3-server"
  ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
  ];

  # The niks3 client shells out to `nix path-info` which differs between Nix and Lix; pinning Nix
  # here allows the format to be consistent. See https://github.com/Mic92/niks3/issues/181
  postInstall = ''
    wrapProgram $out/bin/niks3 --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "S3-backed Nix binary cache with garbage collection";
    homepage = "https://github.com/Mic92/niks3";
    changelog = "https://github.com/Mic92/niks3/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mic92
      philiptaron
    ];
    mainProgram = "niks3";
  };
})
