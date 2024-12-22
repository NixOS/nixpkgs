{
  picom,
  lib,
  writeShellScript,
  fetchFromGitHub,
  unstableGitUpdater,
}:

picom.overrideAttrs (previousAttrs: {
  pname = "picom-pijulius";
  version = "8.2-unstable-2024-12-05";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "9b7d7bdaee0c697f416e3d6b41f1453aeaa07c78";
    hash = "sha256-9HCtbRwDrjB/i89O5igPdyxHo8AKiznltrjTdBjenlk=";
  };

  dontVersionCheck = true;

  passthru.updateScript = unstableGitUpdater {
    tagFormat = "v([A-Z]+)([a-z]+)|v([1-9]).([1-9])|v([1-9])-rc([1-9])";
    tagConverter = writeShellScript "picom-pijulius-tag-converter.sh" ''
      sed -e 's/v//g' -e 's/([A-Z])([a-z])+/8.2/g' -e 's/-rc([1-9])|-rc//g' -e 's/0/8.2/g'
    '';
  };

  meta = {
    inherit (previousAttrs.meta)
      license
      longDescription
      mainProgram
      platforms
      ;

    description = "Pijulius's picom fork with extensive animation support";
    homepage = "https://github.com/pijulius/picom";
    maintainers = with lib.maintainers; [
      YvesStraten
    ];
  };
})
