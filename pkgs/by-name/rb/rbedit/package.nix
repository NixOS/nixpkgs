{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "rbedit";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rbedit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YvJvqLrvuCUBXr0nDIq7LoA400uOjw5gxhpndPi1azg=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dependency-Free Bencode Editor";
    longDescription = ''
      A statically compiled and dependency-free Bencode editor in Go,
      useful for command line use and scripts.
    '';
    homepage = "https://github.com/rakshasa/rbedit";
    changelog = "https://github.com/rakshasa/rbedit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "rbedit";
  };
})
