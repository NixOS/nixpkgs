{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "codeowners";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "hmarr";
    repo = "codeowners";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PMT3ihxCD4TNgTZOD4KB9Od1djIhnlMa8zuD6t1OieU=";
  };

  vendorHash = "sha256-CpGlw4xe+gg2IRov9Atd8Z7XbXs1zkIYxvBVpsY/gxg=";

  meta = {
    description = "CLI and Go library for Github's CODEOWNERS file";
    mainProgram = "codeowners";
    homepage = "https://github.com/hmarr/codeowners";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yorickvp ];
  };
})
