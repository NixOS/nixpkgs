{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  dmenu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "j4-dmenu-desktop";
  version = "unstable-2023-09-12";

  src = fetchFromGitHub {
    owner = "enkore";
    repo = "j4-dmenu-desktop";
    rev = "7e3fd045482a8ea70619e422975b52feabc75175";
    hash = "sha256-8PmfzQkHlEdMbrcQO0bPruP3jaKEcr/17x0/Z7Jedh0=";
  };

  postPatch = ''
    substituteInPlace src/main.cc \
        --replace "dmenu -i" "${lib.getExe dmenu} -i"
  '';

  nativeBuildInputs = [ cmake ];

  # tests are fetching an external git repository
  cmakeFlags = [
    "-DWITH_TESTS=OFF"
    "-DWITH_GIT_CATCH=OFF"
  ];

  meta = with lib; {
    changelog = "https://github.com/enkore/j4-dmenu-desktop/blob/${finalAttrs.src.rev}/CHANGELOG";
    description = "A wrapper for dmenu that recognizes .desktop files";
    homepage = "https://github.com/enkore/j4-dmenu-desktop";
    license = licenses.gpl3Only;
    mainProgram = "j4-dmenu-desktop";
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.unix;
  };
})
