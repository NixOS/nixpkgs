{
  lib,
  fetchFromGitHub,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "youtube-dl";
  version = "1.0-unstable-2018-10-12";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "youtube-dl-emacs";
    rev = "af877b5bc4f01c04fccfa7d47a2c328926f20ef4";
    hash = "sha256-Etl95rcoRACDPjcTPQqYK2L+w8OZbOrTrRT0JadMdH4=";
  };

  ignoreCompilationError = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Emacs youtube-dl download manager";
    homepage = "https://github.com/skeeto/youtube-dl-emacs";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ leungbk ];
  };
}
