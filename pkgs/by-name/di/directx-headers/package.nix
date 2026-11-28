{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "directx-headers";
  version = "1.721.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectX-Headers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mZAyjOEeKzikc1HXbkalqJnHAD8/L6PQJDjJzUzAKXA=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # tests require WSL2
  mesonFlags = [ "-Dbuild-test=false" ];

  meta = {
    description = "Official D3D12 headers from Microsoft";
    homepage = "https://github.com/microsoft/DirectX-Headers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
})
