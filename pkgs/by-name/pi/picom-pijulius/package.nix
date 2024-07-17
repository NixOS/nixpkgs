{
  picom,
  lib,
  writeShellScript,
  fetchFromGitHub,
  pcre,
  unstableGitUpdater,
}:
picom.overrideAttrs (previousAttrs: {
  pname = "picom-pijulius";
  version = "8.2-unstable-2024-07-01";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "b8fe9323e7606709d692976a7fe7d2455b328bc6";
    hash = "sha256-bXeoWg1ZukXv+6ZNeRc8gGNsbtBztyW5lpfK0lQK+DE=";
  };

  buildInputs = (previousAttrs.buildInputs or [ ]) ++ [ pcre ];

  meta = {
    inherit (previousAttrs.meta)
      license
      platforms
      mainProgram
      longDescription
      ;

    description = "Pijulius's picom fork with extensive animation support";
    homepage = "https://github.com/pijulius/picom";
    maintainers = with lib.maintainers; [ YvesStraten ];
  };

  passthru.updateScript = unstableGitUpdater {
    tagFormat = "v([A-Z]+)([a-z]+)|v([1-9]).([1-9])|v([1-9])-rc([1-9])";
    tagConverter = writeShellScript "picom-pijulius-tag-converter.sh" ''
      sed -e 's/v//g' -e 's/([A-Z])([a-z])+/8.2/g' -e 's/-rc([1-9])|-rc//g' -e 's/0/8.2/g'
    '';
  };
})
