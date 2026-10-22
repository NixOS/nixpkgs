{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-rose-pine";
  version = "0-unstable-2025-11-05";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "fcitx5";
    rev = "01c291bc4fa5095c7a7c2ab177a9efc2042c5026";
    hash = "sha256-pNFDzsURMsNUJRz1jjyOb9uLjCtMbNuo3ARvv0rsvLg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/fcitx5/themes/
    cp -rv rose-pine* $out/share/fcitx5/themes/

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Fcitx5 themes based on Rosé Pine";
    homepage = "https://github.com/rose-pine/fcitx5";
    maintainers = with lib.maintainers; [
      rosehobgoblin
      ulic-youthlic
    ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
  };
}
