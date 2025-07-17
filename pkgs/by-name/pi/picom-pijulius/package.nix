{
  picom,
  lib,
  writeShellScript,
  fetchFromGitHub,
  unstableGitUpdater,
}:

picom.overrideAttrs (previousAttrs: {
  pname = "picom-pijulius";
  version = "8.2-unstable-2025-06-22";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "cd609d21fcc17d2935dc1c4e32bc77cd1ffe160f";
    hash = "sha256-zh0oPyoM4phtZ2BedNVyPieIc6HWZrNS6DnEWzlTUy0=";
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
