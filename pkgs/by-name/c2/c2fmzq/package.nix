{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "c2FmZQ";
  version = "0.4.21";

  src = fetchFromGitHub {
    owner = "c2FmZQ";
    repo = "c2FmZQ";
    rev = "v${version}";
    hash = "sha256-i2IO+07Ne3Q5/aBWuAYmkDcDrp5S/yc1eY1vkQI4kgA=";
  };

  ldflags = [ "-s" "-w" ];

  sourceRoot = "${src.name}/c2FmZQ";

  vendorHash = "sha256-cGFI9HSpszi7nXbUCx1MBoj7QOzYseha7+udAbGL+P8=";

  subPackages = [ "c2FmZQ-client" "c2FmZQ-server" ];

  passthru.tests = { inherit (nixosTests) c2fmzq; };

  meta = with lib; {
    description = "Securely encrypt, store, and share files, including but not limited to pictures and videos";
    homepage = "https://github.com/c2FmZQ/c2FmZQ";
    license = licenses.gpl3Only;
    mainProgram = "c2FmZQ-server";
    maintainers = with maintainers; [ hmenke ];
    platforms = platforms.linux;
  };
}
