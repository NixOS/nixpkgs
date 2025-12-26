{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gopls,
  replaceVars,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-go";
  version = "1.3.35";

  src = fetchFromGitHub {
    owner = "josa42";
    repo = "coc-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QmWwqq4WbR88VTd2K/nJDl76SXCo5P3AgTyN7/Cu1vE=";
  };

  patches = [
    ./fix-lockfile.patch
    (replaceVars ./allow-overriding-path.patch { customPath = lib.makeBinPath [ gopls ]; })
  ];

  npmDepsHash = "sha256-U0FrYOw6VubUDuoYYxgUIWp7QNHlr+Usohb/UCbUSGA=";

  meta = {
    description = "Go language server extension using gopls for coc.nvim";
    homepage = "https://github.com/josa42/coc-go";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "coc-go";
    platforms = lib.platforms.all;
  };
})
