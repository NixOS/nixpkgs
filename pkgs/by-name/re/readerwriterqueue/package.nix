{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "readerwriterqueue";
  # Not using a stable version since this one produces
  # readerwriterqueueConfig.cmake needed by dependent packages.
  version = "1.0.6-2024-07-09";

  src = fetchFromGitHub {
    owner = "cameron314";
    repo = "readerwriterqueue";
    rev = "16b48ae1148284e7b40abf72167206a4390a4592";
    hash = "sha256-m4cUIXiDFxTguDZ7d0svjlOSkUNYY0bbUp3t7adBwOo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Fast single-producer, single-consumer lock-free queue for C";
    homepage = "https://github.com/cameron314/readerwriterqueue";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.all;
  };
})
