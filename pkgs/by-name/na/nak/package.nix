{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  fuse3,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nak";
  version = "0.22.3";

  src = fetchFromGitHub {
    owner = "fiatjaf";
    repo = "nak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gsEgPpMjooqlqGEKaxqH+bLOfs1yFxwJV5TRWf5ix0c=";
  };

  vendorHash = "sha256-s2/OtbzLOnCZnBMRqCWdKy1NdXjZ8LLlqoxetd+PYio=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fuse3
  ];

  tags = [ "fuse3" ];
  env.CGO_CFLAGS = "-I${lib.getDev fuse3}/include/fuse3";

  # Integration tests fail (requires connection to relays)
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for Nostr things";
    homepage = "https://github.com/fiatjaf/nak";
    changelog = "https://github.com/fiatjaf/nak/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "nak";
  };
})
