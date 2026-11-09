{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "directx-headers";
  version = "1.619.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectX-Headers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j/oPD44hjk8yH2EUX3gFpBOKWQvoRqBiO9ZH0z/lj/8=";
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
