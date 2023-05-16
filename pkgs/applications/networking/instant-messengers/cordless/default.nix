{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cordless";
  version = "2020-11-22";

  src = fetchFromGitHub {
    owner = "Bios-Marcel";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-nOHLI0N4d8aC7KaWdLezSpVU1DS1fkfW5UO7cVYCbis=";
=======
    sha256 = "0avf09b73fs3wpb4fzmm6ka595aanfvp95m6xj1ccxvq8ciwpqcw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = [ "." ];

<<<<<<< HEAD
  vendorHash = "sha256-XnwTqd19q+hOJZsfnFExiPDbg4pzV1Z9A6cq/jhcVgU=";
=======
  vendorSha256 = "01anbhwgwam70dymcmvkia1xpw48658rq7wv4m7fiavxvnli6z2y";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/Bios-Marcel/cordless";
    description = "Discord terminal client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
