<<<<<<< HEAD
{ lib, fetchFromGitLab, unstableGitUpdater, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "unstable-2023-07-23";
=======
{ lib, fetchFromGitLab, unstableGitUpdater, rustPlatform, scdoc }:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "unstable-2021-09-30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "kile";
<<<<<<< HEAD
    rev = "c24208761d04e0a74d203fc1dcd2f7fed68da388";
    sha256 = "sha256-4iclNVd7nm6LkgvsHwWaWyi1bZL/A+bbT5OSXn70bLs=";
=======
    rev = "b543d435b92498b72609a05048bc368837a7b455";
    sha256 = "sha256-+SjdhSRT6TGbwvgZti8t9wYJx8LEtY3pleDZx/AEkio=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.com/snakedye/kile.git";
  };

<<<<<<< HEAD
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "kilexpr-0.1.0" = "sha256-Bw6vYtzhheAJ8NLQtr3gLjZ9/5ajuABURRYDnVF9W1Y=";
    };
  };
=======
  cargoSha256 = "sha256-W7rq42Pz+l4TSsR/h2teRTbl3A1zjOcIx6wqgnwyQNA=";

  nativeBuildInputs = [ scdoc ];

  postInstall = ''
    mkdir -p $out/share/man
    scdoc < doc/kile.1.scd > $out/share/man/kile.1
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tiling layout generator for river";
    homepage = "https://gitlab.com/snakedye/kile";
    license = licenses.mit;
    platforms = platforms.linux; # It's meant for river, a wayland compositor
    maintainers = with maintainers; [ fortuneteller2k ];
    mainProgram = "kile";
  };
}
