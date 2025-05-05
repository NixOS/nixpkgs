{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "duckdb.yazi";
  version = "25.4.8-unstable-2025-04-28";

  src = fetchFromGitHub {
    owner = "wylie102";
    repo = "duckdb.yazi";
    rev = "02f902dfaf22f20c121da49bfcf5500f4fb11d7d";
    hash = "sha256-fESxJDU7befG2aDxm79M9Eq71RH1UwA4hi0OgK9vPbM=";
  };

  meta = {
    description = "Yazi plugin that uses duckdb to preview data files";
    homepage = "https://github.com/wylie102/duckdb.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
