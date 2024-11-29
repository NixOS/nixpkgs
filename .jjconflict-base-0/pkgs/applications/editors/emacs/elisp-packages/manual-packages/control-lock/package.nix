{
  lib,
  fetchurl,
  melpaBuild,
}:

melpaBuild {
  pname = "control-lock";
  version = "1.1.2";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/emacsmirror/emacswiki.org/185fdc34fb1e02b43759ad933d3ee5646b0e78f8/control-lock.el";
    hash = "sha256-JCrmS3FSGDHSR+eAR0X/uO0nAgd3TUmFxwEVH5+KV+4=";
  };

  meta = {
    homepage = "https://www.emacswiki.org/emacs/control-lock.el";
    description = "Like caps-lock, but for your control key";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
  };
}
