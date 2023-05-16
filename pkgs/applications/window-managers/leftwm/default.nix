{ stdenv, lib, fetchFromGitHub, rustPlatform, libX11, libXinerama }:

let
  rpathLibs = [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-SjEp0gQHwq3Omhx/EPnyLeQJ50Ov0rHDxmYVWBwIDBs=";
  };

  cargoSha256 = "sha256-kdGqnfzO+Ev9QeZcZqISPTehEXZzCWT5S8p6JbTBreE=";
=======
    sha256 = "sha256-ZAlX8Vu4JAwQlwBOHT435Bz3g3qqK5ePm9v0cDqP8Q4=";
  };

  cargoSha256 = "sha256-nn/P9ZZNf1Zts4JiJ2kXWAAG/HT1GnlYHXcPijYiBlU=";

  cargoPatches = [
    ./0001-patch-version.patch
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = rpathLibs;

  postInstall = ''
    for p in $out/bin/left*; do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $p
    done
  '';

  dontPatchELF = true;

  meta = with lib; {
<<<<<<< HEAD
=======
    broken = (stdenv.isLinux && stdenv.isAarch64);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yanganto ];
    changelog = "https://github.com/leftwm/leftwm/blob/${version}/CHANGELOG";
  };
}
