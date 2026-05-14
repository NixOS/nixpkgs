{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "coc-basedpyright";
  # No tagged releases, this version is inferred from <https://www.npmjs.com/package/coc-basedpyright>
  version = "1.19.0-unstable-2025-04-30";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-basedpyright";
    rev = "7d944083c7d4843b1dfa9e05014873b0b5bbb85b";
    hash = "sha256-5Vuw54bSk3WMy8bMsIvtkfDmlx3oocxmD1ykfpErbkc=";
  };

  npmDepsHash = "sha256-hn+Y1f7o/Oz37XXJUPF2CJbrPzZYOY0njrJv+T3ve6w=";

  meta = {
    description = "Basedpyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-basedpyright";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wrvsrx ];
  };
}
