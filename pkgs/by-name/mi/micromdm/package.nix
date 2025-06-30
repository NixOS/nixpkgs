{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "micromdm";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "micromdm";
    repo = "micromdm";
    rev = "v${version}";
    hash = "sha256-o/HK1bjaUwsSQG7QbYe0gFnD/OKV00cHXLXpftNa3iY=";
  };

  vendorHash = "sha256-aKm8a/PS+1ozImh1aL2EliALyUqjPMMBh4NTbL0H/ng=";

  meta = {
    description = "Mobile Device Management server for Apple Devices, focused on giving you all the power through an API";
    homepage = "https://github.com/micromdm/micromdm";
    license = lib.licenses.mit;
    mainProgram = "micromdm";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ neverbehave ];
  };
}
