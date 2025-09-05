{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ggwave";
  version = "unstable-2025-03-21";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "ggwave";
    rev = "bef9afbf0c924160695ef3c84264f5e98c2a0fdf";
    hash = "sha256-9CCfRfzZ38K5m+2kNAwtyYKw2UlbCyxN+bPwHpKLSJg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DGGWAVE_BUILD_EXAMPLES=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/ggerganov/ggwave";
    changelog = "https://github.com/ggerganov/ggwave/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Tiny data-over-sound library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mightyiam ];
    platforms = lib.platforms.all;
  };
})
