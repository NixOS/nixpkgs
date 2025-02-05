{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation {
  pname = "obs-source-clone";
  version = "0.1.4-unstable-2024-02-19";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-clone";
    rev = "d1524d5d932d6841a1fbd6061cc4a0033fb615b7";
    hash = "sha256-W9IIIGQdreI2FQGii5NUB5tVHcqsiYAKTutOHEPCyms=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_OUT_OF_TREE" true)
  ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio to clone sources";
    homepage = "https://github.com/exeldro/obs-source-clone";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
