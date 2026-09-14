{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkgsBuildBuild,
}:

let
  releaseYear = "2026";
  releaseMonth = "jun";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "directxmath";
  version = "${releaseMonth}${releaseYear}";
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
  postInstall = with pkgsBuildBuild.pkgsCross.mingwW64.windows; ''
    install --mode=644 \
      ${mingw_w64_headers}/include/{sal,concurrencysal}.h \
      --target-directory="$out/include"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "All inline SIMD C++ linear algebra library";
    homepage = "https://github.com/microsoft/DirectXMath";
    changelog = "https://github.com/microsoft/DirectXMath/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
