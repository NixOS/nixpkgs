{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  networkmanager,
}:

buildGoModule rec {
  pname = "blueboy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "chetanjangir0";
    repo = "blueboy";
    rev = "v${version}";
    sha256 = "sha256-f9aj0MRdsQPEMhvTwtDyxBEqB1yKJNuP0Yug51ybDhU=";
  };

  vendorHash = "sha256-4rK69s1uTFBV20endymLw6JEUfrh51bznZEgbujUQls=";

  buildInputs = [ networkmanager ];
  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    description = "A simple TUI network manager";
    homepage = "https://github.com/chetanjangir0/blueboy";
    license = licenses.mit;
    maintainers = with maintainers; [ chetanjangir0 ];
    mainProgram = "blueboy";
    platforms = platforms.linux;
  };
}
