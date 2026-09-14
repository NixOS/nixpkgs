{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ggh";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "byawitz";
    repo = "ggh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IjiRz6ierqqjRZB4XBQYwohasx7ByAs7aPt1i2Tv5Eo=";
  };

  vendorHash = "sha256-TVe6Yd3dOmrrcTIEGWnXRG+nCAyE/ygCv/M23ZXXzB4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  # Test requires a HOME dir
  preCheck = ''
    export HOME=$TMPDIR
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Recall your SSH sessions (also search your SSH config file)";
    homepage = "https://github.com/byawitz/ggh";
    changelog = "https://github.com/byawitz/ggh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ilarvne ];
    platforms = lib.platforms.unix;
    mainProgram = "ggh";
  };
})
