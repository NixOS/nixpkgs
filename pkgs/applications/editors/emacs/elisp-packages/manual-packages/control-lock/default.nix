{ lib, trivialBuild, fetchurl }:

trivialBuild {
  pname = "control-lock";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/emacsmirror/emacswiki.org/185fdc34fb1e02b43759ad933d3ee5646b0e78f8/control-lock.el";
    hash = "sha256-JCrmS3FSGDHSR+eAR0X/uO0nAgd3TUmFxwEVH5+KV+4=";
  };

<<<<<<< HEAD
  version = "1.1.2";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "Like caps-lock, but for your control key.  Give your pinky a rest!";
    homepage = "https://www.emacswiki.org/emacs/control-lock.el";
    platforms = lib.platforms.all;
  };
}
