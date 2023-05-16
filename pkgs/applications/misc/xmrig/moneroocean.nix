{ stdenv, fetchFromGitHub, lib, xmrig }:

xmrig.overrideAttrs (oldAttrs: rec {
  pname = "xmrig-mo";
<<<<<<< HEAD
  version = "6.20.0-mo1";
=======
  version = "6.19.2-mo1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-yHAipyZJXwH21u4YwjUqDCsXHVrI+eSnp4Iqt3AZC9A=";
=======
    sha256 = "sha256-L2upscNOTEQTbJ9ZnbXIpqPNmQDv56/7UYzlKndEulc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "A fork of the XMRig CPU miner with support for algorithm switching";
    homepage = "https://github.com/MoneroOcean/xmrig";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ j0hax ];
  };
})
