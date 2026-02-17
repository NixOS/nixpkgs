{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "goverter";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "goverter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T6nsQJxe4YXeWPZf4AxELtTtmNznahAKohv1JqwjuW8=";
  };

  vendorHash = "sha256-wStuQhxrzd+LyHQi+k6ez6JT1xzZcPjJa09WqX70bys=";

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
})
