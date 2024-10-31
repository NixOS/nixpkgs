{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  flavor ? "mocha", # override with your chosen flavor
}:
let
  version = "1.0.0";
in
stdenvNoCC.mkDerivation {
  pname = "catppuccin-grub";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    rev = "v${version}";
    hash = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r src/catppuccin-${flavor}-grub-theme/* "$out/"

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for GRUB";
    homepage = "https://github.com/catppuccin/grub";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [isabelroses mimvoid];
    platforms = lib.platforms.linux;
  };
}
