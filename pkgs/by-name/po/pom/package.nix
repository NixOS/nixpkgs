{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pom";
  version = "0-unstable-2024-04-29";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "pom";
    rev = "a8a2da7043f222b9c849d1ea93726433980469c0";
    hash = "sha256-EAt0Q0gSHngQj2G4qYM3zhUGkl/vqa7J36iajlH4dzs=";
  };

  vendorHash = "sha256-2ghUITtL6RDRVqAZZ+PMj4sYDuh4VaKtGT11eSMlBiA=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Pomodoro timer in your terminal";
    homepage = "https://github.com/maaslalani/pom";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani redyf  ];
    mainProgram = "pom";
  };
}
