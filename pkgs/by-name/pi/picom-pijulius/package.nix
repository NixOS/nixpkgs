{
  picom,
  lib,
  writeShellScript,
  fetchFromGitHub,
  pcre,
  unstableGitUpdater
}:
picom.overrideAttrs (previousAttrs: {
  pname = "picom-pijulius";
  version = "8.2-unstable-2024-06-13";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "a0e818855daba0d2f11a298f7fd238f8a6049167";
    hash = "sha256-w1SWYhPfFGX2EumEe8UBZA3atW4jvW54GsMYLGg59Ys=";
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
