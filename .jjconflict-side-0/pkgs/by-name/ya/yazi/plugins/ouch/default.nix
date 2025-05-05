{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "ouch.yazi";
  version = "0-unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    rev = "2496cd9ac2d1fb52597b22ae84f3af06c826a86d";
    hash = "sha256-OsNfR7rtnq+ceBTiFjbz+NFMSV/6cQ1THxEFzI4oPJk=";
  };

  meta = {
    description = "Yazi plugin to preview archives";
    homepage = "https://github.com/ndtoan96/ouch.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
