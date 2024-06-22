{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "lndhub-go";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "lndhub.go";
    rev = version;
    sha256 = "sha256-PHBzM/lYYu6hXa5jiFQR/K5j+vmxaYH7xuoxOhFbhMk=";
  };

  vendorHash = "sha256-Vo29w04cRW0syD2tjieKVeZ3srFNuEC3T17birVWn6k=";

  doCheck = false; # tests require networking

  meta = with lib; {
    description = "Accounting wrapper for the Lightning Network";
    homepage = "https://github.com/getAlby/lndhub.go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
    mainProgram = "lndhub.go";
  };
}
