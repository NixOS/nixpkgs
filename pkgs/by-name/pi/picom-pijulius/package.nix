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
  version = "8.2-unstable-2024-09-14";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "0c46ea546d9c507e744612e80b25ef5dfa531855";
    hash = "sha256-g/RknjZh5O2/3Plk1w8QnNywWZXZaABfunBY6XyixnA=";
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
