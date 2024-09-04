{ lib
, stdenv
, fetchFromGitHub
, cmake
, cmark
, darwin
, git
, libssh2
, lua5_4
, hunspell
, ninja
, openssl
, pkg-config
, qtbase
, qttools
, wrapQtAppsHook
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

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
    "-DUSE_SYSTEM_CMARK=ON"
    "-DUSE_SYSTEM_GIT=ON"
    "-DUSE_SYSTEM_HUNSPELL=ON"
    # upstream uses its own fork of libgit2 as of 1.2.2, however this may change in the future
    # "-DUSE_SYSTEM_LIBGIT2=ON"
    "-DUSE_SYSTEM_LIBSSH2=ON"
    "-DUSE_SYSTEM_LUA=ON"
    "-DUSE_SYSTEM_OPENSSL=ON"
    "-DENABLE_UPDATE_OVER_GUI=OFF"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    cmark
    git
    hunspell
    libssh2
    lua5_4
    openssl
    qtbase
    qttools
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    Security
  ]);

  postInstall = ''
    # Those are not program libs, just some Qt5 libs that the build system leaks for some reason
    rm -rf $out/{include,lib}
  '';

  meta = with lib; {
    description = "Graphical Git client designed to help you understand and manage your source code history";
    homepage = "https://murmele.github.io/Gittyup";
    license = with licenses; [ mit ];
    maintainers = [ ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
