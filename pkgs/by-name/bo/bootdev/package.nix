{ lib
, buildGoModule
, fetchFromGitHub
,
}:
buildGoModule rec {
  pname = "bootdev";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "bootdotdev";
    repo = "bootdev";
    rev = "v${version}";
    hash = "sha256-5S4XjqajX1Y9XKxfWFDeFVC2d14/C9fo6zytbwXuW7E=";
  };

  vendorHash = "sha256-jhRoPXgfntDauInD+F7koCaJlX4XDj+jQSe/uEEYIMM=";

  doCheck = false;

  meta = with lib; {
    description = "A CLI used to complete coding challenges and lessons on Boot.dev";
    homepage = "https://github.com/bootdotdev/bootdev";
    license = with licenses; [
      mit
    ];
    maintainers = with maintainers; [ jethair ];
    mainProgram = "bootdev";
  };
}
