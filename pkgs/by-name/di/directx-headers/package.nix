{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "directx-headers";
  version = "1.618.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectX-Headers";
    rev = "v${version}";
    hash = "sha256-zKlKUnPHUCDYRBIFU2gpOUvx1d5ZoMy1vYMdByaMIyA=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # tests require WSL2
  mesonFlags = [ "-Dbuild-test=false" ];

  meta = with lib; {
    description = "Official D3D12 headers from Microsoft";
    homepage = "https://github.com/microsoft/DirectX-Headers";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
