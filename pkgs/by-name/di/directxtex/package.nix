{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScript,
  curl,
  jq,
  nix-update,
  cmake,
  directx-headers,
  directxmath,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "directxtex";
  version = "may2026";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXTex";
    tag = finalAttrs.version;
    hash = "sha256-2JqaAbZXOBIZ2oRQGnpAhuoCiZ4OaqNPYnYRkTll9IA=";
  };

  patches = [ ./0001-cmake-fallback-for-directx-headers.patch ];

  # Public headers and the installed CMake config both require these
  propagatedBuildInputs = [
    directx-headers
    directxmath
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # Static archive leaves OpenMP out of the pkg-config file, so link the
  # runtime into a shared library instead.
  cmakeFlags = [ (lib.cmakeBool "BUILD_SHARED_LIBS" true) ];

  # Month-year tags such as `may2026` do not sort as versions, so
  # nix-update would pick the wrong one.  Ask GitHub for the latest
  # release instead.
  passthru.updateScript = writeShellScript "update-directxtex" ''
    set -euo pipefail
    latestTag=$(${lib.getExe curl} ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --fail --location \
      https://api.github.com/repos/microsoft/DirectXTex/releases/latest | ${lib.getExe jq} --raw-output .tag_name)
    exec ${lib.getExe nix-update} directxtex --version="$latestTag"
  '';

  meta = {
    description = "Texture processing library for Direct3D";
    homepage = "https://github.com/microsoft/DirectXTex";
    changelog = "https://github.com/microsoft/DirectXTex/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
