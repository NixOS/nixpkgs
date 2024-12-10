{
  picom,
  lib,
  fetchFromGitHub,
  pcre,
}:
picom.overrideAttrs (previousAttrs: {
  pname = "picom-pijulius";
  version = "8.2-unstable-2024-04-30";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "e7b14886ae644aaa657383f7c4f44be7797fd5f6";
    hash = "sha256-YQVp5HicO+jbvCYSY+hjDTnXCU6aS3aCvbux6NFcJ/Y=";
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
})
