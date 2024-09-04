{
  picom,
  lib,
  writeShellScript,
  fetchFromGitHub,
  pcre,
  asciidoctor,
  unstableGitUpdater
}:
picom.overrideAttrs (previousAttrs: {
  pname = "picom-pijulius";
  version = "8.2-unstable-2024-08-30";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "404652dfca5d6708e3a03e78b7e467550a4f7b62";
    hash = "sha256-VJLMnQpW24OXlCmLoAAkyNMtplzS+NKpUJzLHklkizU=";
  };

  buildInputs = (previousAttrs.buildInputs or [ ]) ++ [ pcre ];
  nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [ asciidoctor ];

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
