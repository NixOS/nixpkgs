{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gitMinimal,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "krew";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3GoC2HEp9XJe853/JYvX9kAAcFf7XxglVEeU9oQ/5Ms=";
  };

  vendorHash = "sha256-r4Dywm0+YxWWD59oaKodkldE2uq8hlt9MwOMYDaj6Gc=";

  subPackages = [ "cmd/krew" ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  postFixup = ''
    wrapProgram $out/bin/krew \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  # krew doesn't support --version and requires kubectl
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package manager for kubectl plugins";
    mainProgram = "krew";
    homepage = "https://github.com/kubernetes-sigs/krew";
    changelog = "https://github.com/kubernetes-sigs/krew/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
})
