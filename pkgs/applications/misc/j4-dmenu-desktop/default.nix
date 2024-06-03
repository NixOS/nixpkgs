{
  lib,
  catch2_3,
  cmake,
  dmenu,
  fetchFromGitHub,
  fmt,
  meson,
  ninja,
  pkg-config,
  spdlog,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "j4-dmenu-desktop";
  version = "r3.0";

  src = fetchFromGitHub {
    owner = "enkore";
    repo = "j4-dmenu-desktop";
    rev = finalAttrs.version;
    hash = "sha256-/HlH7BIQvsczzXm8SFwSRKlt5kj38l3DYFJ655J1qas=";
  };

  postPatch = ''
    substituteInPlace src/main.cc \
        --replace-fail "dmenu -i" "${lib.getExe dmenu} -i"
  '';

  nativeBuildInputs = [
    catch2_3
    cmake
    fmt
    meson
    ninja
    pkg-config
    spdlog
  ];

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
