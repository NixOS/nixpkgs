{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nix,
}:

buildGoModule (finalAttrs: {
  pname = "niks3";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "niks3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zskaX55kGzbFFO0UGwTsOpALEzPTSIycgbrQRurlVz8=";
  };

  vendorHash = "sha256-/3klr19Rfz4dZrv8cWPaClLw1FgKfgqnBaR7KCydfQE=";

  subPackages = [
    "cmd/niks3"
    "cmd/niks3-server"
  ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  # The niks3 client shells out to `nix path-info` which differs between Nix and Lix; pinning Nix
  # here allows the format to be consistent. See https://github.com/Mic92/niks3/issues/181
  postInstall = ''
    wrapProgram $out/bin/niks3 --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = {
    description = "S3-backed Nix binary cache with garbage collection";
    homepage = "https://github.com/Mic92/niks3";
    changelog = "https://github.com/Mic92/niks3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mic92
      philiptaron
    ];
    mainProgram = "niks3";
  };
})
