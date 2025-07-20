{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "goverter";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "goverter";
    tag = "v${version}";
    hash = "sha256-8USfEIwGXJN62iN9+1WSRKiKoki22a1r50ZBKs6wHfg=";
  };

  vendorHash = "sha256-YOtcidMhtQqw/KxY1R3L3XnrhayGQBvHkRdbvYyCQFM=";

  subPackages = [ "cmd/goverter" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate type-safe Go converters by defining function signatures";
    homepage = "https://github.com/jmattheis/goverter";
    changelog = "https://goverter.jmattheis.de/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ krostar ];
    mainProgram = "goverter";
  };
}
