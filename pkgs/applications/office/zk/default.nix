{ lib, fetchFromGitHub, buildGoModule, icu }:

buildGoModule rec {
  pname = "zk";
<<<<<<< HEAD
  version = "0.14.0";
=======
  version = "0.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mickael-menu";
    repo = "zk";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-c0Grk5Bs9MOzuvWYbp+Y6cHouljUWoM3i7vFmQRFR18=";
  };

  vendorHash = "sha256-23m0fHYJl3X2uHCFnMYID9umTjZvGFoOKTtRrerlWKg=";
=======
    sha256 = "sha256-Q1MU2NGeVjBNnwoAWuoO18xhtt+bdQ2ms37tHnW+R94=";
  };

  vendorHash = "sha256-11GzI3aEhKKTiULoWq9uIc66E3YCrW/HJQUYXRhCaek=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  CGO_ENABLED = 1;

  ldflags = [ "-s" "-w" "-X=main.Build=${version}" ];

  tags = [ "fts5" ];

  meta = with lib; {
    maintainers = with maintainers; [ pinpox ];
    license = licenses.gpl3;
    description = "A zettelkasten plain text note-taking assistant";
    homepage = "https://github.com/mickael-menu/zk";
  };
}
