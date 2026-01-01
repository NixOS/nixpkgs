{
  lib,
  fetchFromGitHub,
  telegram-desktop,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "64gram";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (old: rec {
    pname = "64gram-unwrapped";
<<<<<<< HEAD
    version = "1.1.88";
=======
    version = "1.1.84";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    src = fetchFromGitHub {
      owner = "TDesktop-x64";
      repo = "tdesktop";
      tag = "v${version}";
<<<<<<< HEAD
      hash = "sha256-zC51hlfi4EwqaDBTQev7KAYvQmUMJl1RBWh5/By2GUU=";
=======
      hash = "sha256-CtDCrgKZpaTdR+Eh9H1uq7EmO0SFIgHKlW/zeeWBaCM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fetchSubmodules = true;
    };

    meta = {
      description = "Unofficial Telegram Desktop providing Windows 64bit build and extra features";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
      homepage = "https://github.com/TDesktop-x64/tdesktop";
      changelog = "https://github.com/TDesktop-x64/tdesktop/releases/tag/v${version}";
      maintainers = with lib.maintainers; [ clot27 ];
      mainProgram = "Telegram";
    };
  });
}
