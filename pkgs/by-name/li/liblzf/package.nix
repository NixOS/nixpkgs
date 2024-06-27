{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation {
  name = "liblzf";
  src = fetchzip {
    urls = [
      "http://dist.schmorp.de/liblzf/Attic/liblzf-3.6.tar.gz"
    ];
    hash = "sha256-m5MZfYAT9AtAXh2zk3lZasTfTGVbY8KWnyeftMaLanQ=";
  };
  meta = {
    description = "A small data compression library";
    homepage = "http://software.schmorp.de/pkg/liblzf.html";
    license = lib.licenses.bsd2 // {
      # Alternatively available under gpl2
      url = "http://cvs.schmorp.de/liblzf/LICENSE?revision=1.7&view=markup";
    };
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    platforms = lib.platforms.all;
  };
}
