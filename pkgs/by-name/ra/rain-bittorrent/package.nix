{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rain";
<<<<<<< HEAD
  version = "2.2.3";
=======
  version = "2.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-phBZ1hIH6o4q8CU6+dheZG78OcO+e7YvJoC6hyHHNb4=";
  };

  vendorHash = "sha256-U4NZR3vJRLTrhE1CoCAB+7pkVnvxlJpbLmIGMFuZzWc=";
=======
    hash = "sha256-FU0RjWT+ewM/13n/4zCdxLVrN8ikUJCtosXsx8L8vMk=";
  };

  vendorHash = "sha256-TFIrepXZPokVu9lW2V2s3seq58yQiHceu+zRHucB+0g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "BitTorrent client and library in Go";
    homepage = "https://github.com/cenkalti/rain";
    license = lib.licenses.mit;
    mainProgram = "rain";
    maintainers = with lib.maintainers; [
      justinrubek
      matthewdargan
    ];
  };
}
