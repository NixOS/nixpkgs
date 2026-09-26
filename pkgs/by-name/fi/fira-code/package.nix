{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  useVariableFont ? true,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fira-code";
  version = "6.2";

  src = fetchzip {
    url = "https://github.com/tonsky/FiraCode/releases/download/${finalAttrs.version}/Fira_Code_v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-UHOwZL9WpCHk6vZaqI/XfkZogKgycs5lWg1p0XdQt0A=";
  };

  # only extract the variable font because everything else is a duplicate
  preInstall = "cd ${lib.optionalString useVariableFont "variable_"}ttf";

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/tonsky/FiraCode";
    description = "Monospace font with programming ligatures";
    longDescription = ''
      Fira Code is a monospace font extending the Fira Mono font with
      a set of ligatures for common programming multi-character
      combinations.
    '';
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.rycee ];
    platforms = lib.platforms.all;
  };
})
