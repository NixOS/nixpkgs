{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  directx-headers,
  directxmath,
  pkg-config,
}:

let
  releaseYear = "2026";
  releaseMonth = "may";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "directxtex";
  version = "${releaseMonth}${releaseYear}";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXTex";
    tag = finalAttrs.version;
    hash = "sha256-2JqaAbZXOBIZ2oRQGnpAhuoCiZ4OaqNPYnYRkTll9IA=";
  };

  patches = [ ./0001-cmake-fallback-for-directx-headers.patch ];

  buildInputs = [
    directx-headers
    directxmath
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "DirectXTex texture processing library";
    homepage = "https://github.com/microsoft/DirectXTex";
    changelog = "https://github.com/microsoft/DirectXTex/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
