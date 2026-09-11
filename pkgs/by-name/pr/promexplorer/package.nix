{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  openssl,
}:
buildNimPackage (finalAttrs: {
  pname = "promexplorer";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "marcusramberg";
    repo = "promexplorer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j86NINqCNPuW8v5VcLbyvRUATN94d10xcQYAYSSPYBA=";
  };
  buildInputs = [ openssl ];

  lockFile = ./lock.json;

  meta = {
    description = "Simple tool to explore prometheus exporter metrics";
    homepage = "https://github.com/marcusramberg/promexplorer";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ marcusramberg ];
    mainProgram = "promexplorer";
  };
})
