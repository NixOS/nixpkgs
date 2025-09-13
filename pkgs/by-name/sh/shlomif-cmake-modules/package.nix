{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "shlomif-cmake-modules";
  version = "0-unstable-2023-01-03";

  src = fetchFromGitHub {
    owner = "shlomif";
    repo = "shlomif-cmake-modules";
    rev = "2fa3e9be1a1df74ad0e10f0264bfa60e1e3a755c";
    hash = "sha256-MNGpegbZRwfD8A3VHVNYrDULauLST3Nt18/3Ht6mpZw=";
  };

  installPhase = ''
    runHook preInstall

    install -D $src/shlomif-cmake-modules/* -t $out/lib/cmake

    runHook postInstall
  '';

  meta = {
    description = "CMake modules which are used across Shlomi Fish’s projects";
    homepage = "https://github.com/shlomif/shlomif-cmake-modules";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
