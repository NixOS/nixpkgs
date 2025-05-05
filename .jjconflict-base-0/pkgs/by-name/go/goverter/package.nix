{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "goverter";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "goverter";
    tag = "v${version}";
    hash = "sha256-VgwmnB6FP7hlUrZpKun38T4K2YSDl9yYuMjdzsEhCF4=";
  };

  vendorHash = "sha256-uQ1qKZLRwsgXKqSAERSqf+1cYKp6MTeVbfGs+qcdakE=";

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
