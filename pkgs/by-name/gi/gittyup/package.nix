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
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gittyup";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Murmele";
    repo = "Gittyup";
    rev = "gittyup_v${finalAttrs.version}";
    hash = "sha256-A4+t0glZC8vi+E3+WcTMZ0cdUhHaZZrcP2MGPk45X0g=";
    fetchSubmodules = true;
  };

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
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    cmark
    git
    hunspell
    libssh2
    lua5_4
    openssl
    qt6.qtbase
    qt6.qttools
  ];

  postInstall = ''
    # Those are not program libs, just some Qt5 libs that the build system leaks for some reason
    rm -rf $out/{include,lib}
  '';

  meta = {
    description = "Graphical Git client designed to help you understand and manage your source code history";
    homepage = "https://murmele.github.io/Gittyup";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      fliegendewurst
      phijor
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
