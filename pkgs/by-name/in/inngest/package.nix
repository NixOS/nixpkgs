{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "inngest";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "inngest";
    repo = "inngest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5biiAozUwQlZn5VPHvon1aEOL1pc9MGFfhyCqUtvQFw=";
  };

  vendorHash = null;

  subPackages = [ "cmd" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/inngest/inngest/pkg/inngest/version.Version=${finalAttrs.version}"
  ];

  # Match goreleaser env: CGO_ENABLED=0
  env.CGO_ENABLED = 0;

  # Rename binary to match goreleaser config: binary: inngest
  postInstall = ''
    mv $out/bin/cmd $out/bin/inngest
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The developer platform for easily building reliable workflows";
    homepage = "https://www.inngest.com/";
    license = lib.licenses.sspl;
    maintainers = with lib.maintainers; [ jpwilliams ];
    mainProgram = "inngest";
  };
})
