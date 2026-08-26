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
  version = "0-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "198eba2071d80e4a23b8f51a5859e8f4acf8de6c";
    hash = "sha256-2hGe8VOj1EhpwX51q8AcTfuVBByEHskBj89FX5YZqXc=";
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
