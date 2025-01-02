{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  colors ? [ "all" ], # Default to install all available colors
  additionalInstallationTweaks ? [ ], # Additional installation tweaks
}:
assert lib.assertMsg (colors != [ ]) "The `colors` list can not be empty";
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "marble-shell-theme";
  version = "46.2.3";

  src = fetchFromGitHub {
    owner = "imarkoff";
    repo = "Marble-shell-theme";
    rev = "5971b15d8115c60c3a16b1d219ecffd2cfcdb323";
    hash = "sha256-TX6BSS29EAi2PjL1fMvEKD12RjB9xrfqPSQsJJrUcJg=";
  };

  nativeBuildInputs = [ python3 ];

  patchPhase = ''
    runHook prePatch
    substituteInPlace scripts/config.py \
      --replace-fail "~/.themes" ".themes"
    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    python install.py ${
      lib.escapeShellArgs (map (color: "--${color}") colors)
    } ${lib.escapeShellArgs additionalInstallationTweaks}
    cp -r .themes/* $out/share/themes/
    runHook postInstall
  '';

  meta = {
    description = "Shell theme for GNOME DE";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    homepage = "https://github.com/imarkoff/Marble-shell-theme";
    changelog = "https://github.com/imarkoff/Marble-shell-theme/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ aucub ];
  };
})
