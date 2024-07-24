{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "sway-scratch";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "aokellermann";
    repo = "sway-scratch";
    rev = "v${version}";
    hash = "sha256-wfwCg51Pfj4IGqOYK2Y/4If7PzZv9JHXewVWQDgbPko=";
  };

  cargoHash = "sha256-8rWXJCrm0rTe9jxg9g+40c2Ks5mcqQAIlCIUoEbKFDc=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Automatically starting named scratchpads for sway";
    homepage = "https://github.com/aokellermann/sway-scratch";
    license = licenses.mit;
    maintainers = with maintainers; [ LilleAila ];
    mainProgram = "sway-scratch";
    platforms = lib.platforms.linux;
  };
}
