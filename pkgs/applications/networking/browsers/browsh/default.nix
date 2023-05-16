{ lib, buildGoModule, fetchurl, fetchFromGitHub }:

let
<<<<<<< HEAD
  version = "1.8.2";
=======
  version = "1.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # TODO: must build the extension instead of downloading it. But since it's
  # literally an asset that is indifferent regardless of the platform, this
  # might be just enough.
  webext = fetchurl {
    url = "https://github.com/browsh-org/browsh/releases/download/v${version}/browsh-${version}.xpi";
<<<<<<< HEAD
    hash = "sha256-04rLyQt8co3Z7UJnDJmj++E4n7of0Zh1jQ90Bfwnx5A=";
=======
    sha256 = "sha256-12xWbf4ngYHWLKV9yyxyi0Ny/zHSj2o7Icats+Ef+pA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

in

buildGoModule rec {
  inherit version;

  pname = "browsh";

<<<<<<< HEAD
  sourceRoot = "${src.name}/interfacer";
=======
  sourceRoot = "source/interfacer";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "browsh-org";
    repo = "browsh";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KbBVcNuERBL94LuRx872zpjQTzR6c5GalsBoNR52SuQ=";
  };

  vendorHash = "sha256-eCvV3UuM/JtCgMqvwvqWF3bpOmPSos5Pfhu6ETaS58c=";
=======
    sha256 = "sha256-/tH1w6qi+rimsqtk8Y8AYljU3X4vbmoDtV07piWSBdw=";
  };

  vendorSha256 = "sha256-eCvV3UuM/JtCgMqvwvqWF3bpOmPSos5Pfhu6ETaS58c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preBuild = ''
    cp "${webext}" src/browsh/browsh.xpi
  '';

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "A fully-modern text-based browser, rendering to TTY and browsers";
    homepage = "https://www.brow.sh/";
    maintainers = with maintainers; [ kalbasit siraben ];
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
