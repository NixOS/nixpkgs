{
  picom,
  lib,
  writeShellScript,
  fetchFromGitHub,
  unstableGitUpdater,
}:

picom.overrideAttrs (previousAttrs: {
  pname = "picom-pijulius";
  version = "8.2-unstable-2026-01-24";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "cb09df27efb4cd78417926f02338e93805067730";
    hash = "sha256-/8865rKifoRk73YVul6IaDYmF2q1oFD9TCXDAIEEy5Q=";
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
