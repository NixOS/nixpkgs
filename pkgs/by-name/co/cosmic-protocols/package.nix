{
  lib,
  stdenv,
  fetchFromGitHub,
  wayland-scanner,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "cosmic-protocols";
  version = "0-unstable-2025-03-21";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "ee0d46f4b7e1508011a98225f14c4a0528ab2914";
    hash = "sha256-oD9BYWX0uPpdsOYAyFq/pI6zxM0SfEb8lq9QA2yrBZY=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Additional wayland-protocols used by the COSMIC desktop environment";
    license = with lib.licenses; [
      mit
      gpl3Only
    ];
    maintainers = with lib.maintainers; [
      nyabinary
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
  };
}
