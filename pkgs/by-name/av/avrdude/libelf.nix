{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "libelf";
  version = "0.8.13-unstable-2023-01-14";

  src = fetchFromGitHub {
    owner = "avrdudes";
    repo = "libelf";
    rev = "0c55bfe1d3020a20bddf6ce57c0d9d98ccb12586";
    hash = "sha256-jz7Ef0Eg673IJVZvVNklY40s13LCuMVAc7FGrRI7scQ=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp liblibelf.a $out/lib/libelf.a
    cp -r $src/include $out/include
    runHook postInstall
  '';

  meta = {
    description = "ELF object file access library (vendored by avrdudes)";
    homepage = "https://github.com/avrdudes/libelf";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
  };
}
