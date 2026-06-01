{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pocketbase";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4myp2MleKb6mAwDKhN39uyc5PZJhB3lvm2x/KDR9u0g=";
  };

  vendorHash = "sha256-VBsClxCOA9Mp/kCHQKuBPd2Nt5sfXkVRx/8mGk5Gkcg=";

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  env.CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thilobillerbeck
    ];
    mainProgram = "pocketbase";
  };
})
