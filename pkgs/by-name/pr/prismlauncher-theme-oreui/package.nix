{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  prismlauncher,
}:

stdenvNoCC.mkDerivation rec {
  pname = "prismlauncher-theme-oreui";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "ninsent";
    repo = "Ore-UI-theme-pack";
    tag = "${version}";
    hash = "sha256-wkbqrPrDZjVZ0S/3125YPajqoyGccISZ6l5tVk0+Rvs=";
  };

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/PrismLauncher/iconthemes
    cp -r "Ore UI - Icon Pack" "$out/share/PrismLauncher/iconthemes/"

    mkdir $out/share/PrismLauncher/themes
    cp -r "Ore UI - Dark Amethyst" "$out/share/PrismLauncher/themes/"
    cp -r "Ore UI - Dark Diamond" "$out/share/PrismLauncher/themes/"
    cp -r "Ore UI - Dark Emerald" "$out/share/PrismLauncher/themes/"
    cp -r "Ore UI - Light Amethyst" "$out/share/PrismLauncher/themes/"
    cp -r "Ore UI - Dark Diamond" "$out/share/PrismLauncher/themes/"
    cp -r "Ore UI - Dark Emerald" "$out/share/PrismLauncher/themes/"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    inherit (prismlauncher.meta) platforms;
    description = "Minecraft Bedrock inspired Ore UI theme for Prism Launcher.";
    longDescription = ''
      PrismLauncher theme and icon theme insipired by Minecraft Bedrock Ore UI.
    '';
    homepage = "https://github.com/ninsent/Ore-UI-theme-pack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ssnoer ];
  };
}
