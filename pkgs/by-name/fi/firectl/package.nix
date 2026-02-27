{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "firectl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = "firectl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3MNNgFRq4goWdHFyqWNMAl2K0eKfd03BF05i82FIzNE=";
  };

  vendorHash = "sha256-rD+QCQKgCZU5ktItV8NYqoyQPR7lk8sutvJwSJxFfZQ=";

  doCheck = false;

  meta = {
    description = "Command-line tool to run Firecracker microVMs";
    homepage = "https://github.com/firecracker-microvm/firectl";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "firectl";
  };
})
