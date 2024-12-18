{
  lib,
  fetchFromGitHub,
  melpaBuild,
}:

melpaBuild {
  pname = "grid";
  version = "20240526.1305";

  src = fetchFromGitHub {
    owner = "ichernyshovvv";
    repo = "grid.el";
    rev = "564eccf4e009955f1a6c268382d00e157d4eb302";
    hash = "sha256-3QDw4W3FbFvb2zpkDHAo9BJKxs3LaehyvUVJPKqS9RE=";
  };

  meta = {
    homepage = "https://github.com/ichernyshovvv/grid.el";
    description = "Library to put text data into boxes and manipulate them";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
