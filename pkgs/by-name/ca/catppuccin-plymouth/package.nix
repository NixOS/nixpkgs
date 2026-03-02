{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  variant ? "macchiato",
}:

let
  pname = "catppuccin-plymouth";
  validVariants = [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];
in
assert lib.assertOneOf "${pname}: color variant" variant validVariants;

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;
  version = "0-unstable-2026-02-18";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "da38011d25f6f36152f2409372dfadb11c8f047c";
    hash = "sha256-3JK4lX2ZmxysITDEEkhBLkyINUeCzvu5nUgrpvWZ+ZE=";
  };

  sourceRoot = "${finalAttrs.src.name}/themes/catppuccin-${variant}";

  installPhase = ''
    runHook preInstall

    sed -i 's:\(^ImageDir=\)/usr:\1'"$out"':' catppuccin-${variant}.plymouth
    mkdir -p $out/share/plymouth/themes/catppuccin-${variant}
    cp * $out/share/plymouth/themes/catppuccin-${variant}

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Soothing pastel theme for Plymouth";
    homepage = "https://github.com/catppuccin/plymouth";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      johnrtitor
      spectre256
    ];
  };
})
