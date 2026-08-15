{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gitUpdater,
}:
melpaBuild {
  pname = "dir-config";
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "jamescherti";
    repo = "dir-config.el";
    rev = "5620beabc842f5d63c02c90d28618d5c67fdf94e";
    hash = "sha256-s+aKzPe0LSg875G6l6uSsmgdCqYYwqSt7DH4GXNSEms=";
  };

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/jamescherti/dir-config.el";
    description = "Automatically find and load the .dir-config.el Elisp file";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ johnhamelink ];
  };
}
