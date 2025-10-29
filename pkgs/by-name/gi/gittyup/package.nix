{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmark,
  git,
  libssh2,
  lua5_4,
  hunspell,
  ninja,
  openssl,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "gittyup";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Murmele";
    repo = "Gittyup";
    rev = "gittyup_v${version}";
    hash = "sha256-anyjHSF0ZCBJTuqNdH49iwngt3zeJZat5XGDsKbiwPE=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix GCC 14 build error (remove for next update)
    # https://github.com/Murmele/Gittyup/pull/759
    ./0001-Fix-incorrect-order-of-argument-to-calloc-345.patch
  ];

  cmakeFlags =
    let
      inherit (lib) cmakeBool;
    in
    [
      (cmakeBool "BUILD_SHARED_LIBS" false)
      (cmakeBool "USE_SYSTEM_CMARK" true)
      (cmakeBool "USE_SYSTEM_GIT" true)
      (cmakeBool "USE_SYSTEM_HUNSPELL" true)
      # upstream uses its own fork of libgit2 as of 1.2.2, however this may change in the future
      # (cmakeBool "USE_SYSTEM_LIBGIT2" true)
      (cmakeBool "USE_SYSTEM_LIBSSH2" true)
      (cmakeBool "USE_SYSTEM_LUA" true)
      (cmakeBool "USE_SYSTEM_OPENSSL" true)
      (cmakeBool "ENABLE_UPDATE_OVER_GUI" false)
    ];

  nativeBuildInputs = [
    cmake
    cmark
    ninja
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    cmark
    git
    hunspell
    libssh2
    lua5_4
    openssl
    libsForQt5.qtbase
    libsForQt5.qttools
  ];

  postInstall = ''
    # Those are not program libs, just some Qt5 libs that the build system leaks for some reason
    rm -rf $out/{include,lib}
  '';

  meta = with lib; {
    description = "Graphical Git client designed to help you understand and manage your source code history";
    homepage = "https://murmele.github.io/Gittyup";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      fliegendewurst
      phijor
    ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
