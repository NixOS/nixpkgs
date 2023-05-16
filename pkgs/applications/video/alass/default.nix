{ lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, ffmpeg
}:

rustPlatform.buildRustPackage rec {
  pname = "alass";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kaegi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q1IV9TtmznpR7RO75iN0p16nmTja5ADWqFj58EOPWvU=";
  };

  cargoSha256 = "sha256-6swIoVp1B4CMvaGvq868LTKkzpI6zFKJNgUVqjdyH20=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/alass-cli" --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Automatic Language-Agnostic Subtitles Synchronization";
    homepage = "https://github.com/kaegi/alass";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "alass-cli";
=======
    description = "Automatic Language-Agnostic Subtitle Synchronization";
    homepage = "https://github.com/kaegi/alass";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ erictapen ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
