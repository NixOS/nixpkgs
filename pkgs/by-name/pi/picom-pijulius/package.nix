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
  version = "8.2-unstable-2024-10-30";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "bdbcae085c1ba6c2ec6f21712ed140daaa630d89";
    hash = "sha256-3S8p4vXfryL3IfWPpjhp1GxqJelHRw5aFI3a+ysRKTU=";
  };

  buildInputs = (previousAttrs.buildInputs or [ ]) ++ [ pcre ];
  nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [ asciidoctor ];

  dontVersionCheck = true;

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
