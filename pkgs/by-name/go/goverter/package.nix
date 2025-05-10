{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "goverter";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "goverter";
    tag = "v${version}";
    hash = "sha256-f+rTEbr4Cr5PjXZg+E2235opxbakoYkJqEGRtyWrngE=";
  };

  vendorHash = "sha256-YOtcidMhtQqw/KxY1R3L3XnrhayGQBvHkRdbvYyCQFM=";

  subPackages = [ "cmd/goverter" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate type-safe Go converters by defining function signatures.";
    homepage = "https://github.com/jmattheis/goverter";
    changelog = "https://goverter.jmattheis.de/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ krostar ];
    mainProgram = "goverter";
  };
}
