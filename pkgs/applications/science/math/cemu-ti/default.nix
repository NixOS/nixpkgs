{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qt6
, libarchive
, libpng
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "CEmu";
  version = "2.0";
  src = fetchFromGitHub {
    owner = "CE-Programming";
    repo = "CEmu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fohsIJrvPDMmYHoPbmYQlKLMnj/B3XEBaerZYuqxvd8=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/gui/qt/";

  patches = [
    # This is resolved upstream, but I can't apply the patch because the
    # sourceRoot isn't set to the base of the Git repo.
    ./resolve-ambiguous-constexpr.patch
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    libarchive
    libpng
  ];

  meta = with lib; {
    description = "Third-party TI-84 Plus CE / TI-83 Premium CE emulator, focused on developer features";
    mainProgram = "CEmu";
    homepage = "https://ce-programming.github.io/CEmu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ clevor ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
    broken = stdenv.hostPlatform.isDarwin || (stdenv.system == "x86_64-linux");
  };
})
