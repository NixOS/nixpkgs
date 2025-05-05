{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "full-border.yazi";
  version = "25.2.26-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "92f78dc6d0a42569fd0e9df8f70670648b8afb78";
    hash = "sha256-mqo71VLZsHmgTybxgqKNo9F2QeMuCSvZ89uen1VbWb4=";
  };

  meta = {
    description = "Add a full border to Yazi to make it look fancier";
    homepage = "https://yazi-rs.github.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
