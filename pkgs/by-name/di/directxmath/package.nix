{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScript,
  curl,
  jq,
  nix-update,
  cmake,
  pkgsBuildBuild,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "directxmath";
  version = "jun2026";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXMath";
    tag = finalAttrs.version;
    hash = "sha256-iKUCtMDZklxLcNqaP0hNRfqhyd049xXZB0iF6D6DoWM=";
  };

  nativeBuildInputs = [ cmake ];

  # DirectXMath includes `<sal.h>`, which only exists in the Windows
  # SDK.  Non-Windows consumers need a shim on the include path, so we
  # ship the mingw-w64 CRT copy.
  # See <https://github.com/microsoft/DirectXMath#compiler-support>
  postInstall = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    install --mode=644 \
      ${pkgsBuildBuild.pkgsCross.mingwW64.windows.mingw_w64_headers}/include/{sal,concurrencysal}.h \
      --target-directory="$out/include"
  '';

  # Month-year tags such as `jun2026` do not sort as versions, so
  # nix-update would pick the wrong one.  Ask GitHub for the latest
  # release instead.
  passthru.updateScript = writeShellScript "update-directxmath" ''
    set -euo pipefail
    latestTag=$(${lib.getExe curl} ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --silent --fail --location \
      https://api.github.com/repos/microsoft/DirectXMath/releases/latest | ${lib.getExe jq} --raw-output .tag_name)
    exec ${lib.getExe nix-update} directxmath --version="$latestTag"
  '';

  meta = {
    description = "All inline SIMD C++ linear algebra library";
    homepage = "https://github.com/microsoft/DirectXMath";
    changelog = "https://github.com/microsoft/DirectXMath/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      # `sal.h` and `concurrencysal.h` from mingw-w64
      publicDomain
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
