{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
<<<<<<< HEAD
  version = "6.0.0";
=======
  version = "5.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Rm/W3Q5mb+qkrUYqWK83fi1FgO4KoL7+MjTuvhvY/qk=";
  };

  vendorHash = "sha256-YXybBVGCbdsP2pP7neHWI7KhkpE3tRo9Wpsx1RaEn9w=";
=======
    sha256 = "sha256-DYZqvLuPcoek07YJLur/By9Wi2VxDz6C7jAOVmdKt4Y=";
  };

  vendorHash = "sha256-t6uhFvuR54Q4nYur/3oBzAbBTaIjzHfx7GeEk6X/0os=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-X main.version=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ das_j ];
  };
}
