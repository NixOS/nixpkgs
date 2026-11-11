{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage (finalAttrs: {
  pname = "promexplorer";
  version = "0.0.5";
  src = fetchFromGitHub {
    owner = "marcusramberg";
    repo = "promexplorer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a+9afqdgLgGf2hOWf/QsElq+CurDfE1qDmYCzodZIDU=";
  };

  lockFile = ./lock.json;

  meta = {
    broken = true; # requires pcre support, but nim only supports pcre v1
    description = "Simple tool to explore prometheus exporter metrics";
    homepage = "https://github.com/marcusramberg/promexplorer";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ marcusramberg ];
    mainProgram = "promexplorer";
  };
})
