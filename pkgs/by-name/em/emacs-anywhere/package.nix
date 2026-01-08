{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "emacs-anywhere";
  version = "0-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "nohzafk";
    repo = "emacs-anywhere";
    rev = "58fcdd5565a41555092c0801029d46f5f48b7814";
    sha256 = "sha256-ZHzJfABFnpquIsP6UknusPeYmx20p090JyvVMhJ/OOs=";
  };

  installPhase = ''
    cp -R EmacsAnywhere.spoon/ $out/
  '';

  meta = {
    description = "Edit text from any macOS application in Emacs";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DamienCassou ];
  };
})
