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
lib.checkListOfEnum "${pname}: color variant" validVariants [ variant ]

  stdenvNoCC.mkDerivation
  (finalAttrs: {
    inherit pname;
    version = "0-unstable-2024-10-19";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "plymouth";
      rev = "e0f58d6fcf3dbc2d35dfc4fec394217fbfa92666";
      hash = "sha256-He6ER1QNrJCUthFoBBGHBINouW/tozxQy3R79F5tsuo=";
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

    meta = with lib; {
      description = "Soothing pastel theme for Plymouth";
      homepage = "https://github.com/catppuccin/plymouth";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [
        johnrtitor
        spectre256
      ];
    };
  })
