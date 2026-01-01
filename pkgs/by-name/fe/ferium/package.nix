{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "ferium";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "gorilla-devs";
    repo = "ferium";
    rev = "v${version}";
    hash = "sha256-eeQjezB6pRdnPADLgDLo8b+bUSP12gfBhFNt/uYCwHU=";
  };

  cargoHash = "sha256-3YKFKngyLg2ah4GY+LlbPbnVks7/xFawnMf3D1gjmwI=";

  # Disable the GUI file picker so that GTK/XDG dependencies aren't used
  buildNoDefaultFeatures = true;

  # Requires an internet connection
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/ferium complete $shell > ferium.$shell
      installShellCompletion ferium.$shell
    done
  '';

<<<<<<< HEAD
  meta = {
    description = "Fast and multi-source CLI program for managing Minecraft mods and modpacks from Modrinth, CurseForge, and GitHub Releases";
    mainProgram = "ferium";
    homepage = "https://github.com/gorilla-devs/ferium";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Fast and multi-source CLI program for managing Minecraft mods and modpacks from Modrinth, CurseForge, and GitHub Releases";
    mainProgram = "ferium";
    homepage = "https://github.com/gorilla-devs/ferium";
    license = licenses.mpl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      leo60228
      soupglasses
    ];
  };
}
