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
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Murmele";
    repo = "Gittyup";
    rev = "gittyup_v${version}";
    hash = "sha256-JJ20vls/NGkm0xV+vDguvuW5yqhOQf83TMvnn5Kx4IE=";
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
    mkdir -p $out/bin

    # Move binaries to the proper place
    # TODO: Tweak in the next release: https://github.com/Murmele/Gittyup/commit/5b93e7e514b887fafb00a8158be5986e6c12b2e3
    mv $out/Gittyup $out/bin/gittyup
    mv $out/{indexer,relauncher} $out/bin

    # Those are not program libs, just some Qt5 libs that the build system leaks for some reason
    rm -f $out/*.so.*
    rm -rf $out/{include,lib,Plugins,Resources}
 '' + lib.optionalString stdenv.isLinux ''
    # Install icons
    install -Dm0644 ${src}/rsrc/Gittyup.iconset/gittyup_logo.svg $out/share/icons/hicolor/scalable/apps/gittyup.svg
    for res in 16x16 32x32 64x64 128x128 256x256 512x512; do
      install -Dm0644 ${src}/rsrc/Gittyup.iconset/icon_$res.png $out/share/icons/hicolor/$res/apps/gittyup.png
    done

    # Install desktop file
    install -Dm0644 ${src}/rsrc/linux/com.github.Murmele.Gittyup.desktop $out/share/applications/gittyup.desktop
    # TODO: Remove in the next release: https://github.com/Murmele/Gittyup/commit/5b93e7e514b887fafb00a8158be5986e6c12b2e3
    substituteInPlace $out/share/applications/gittyup.desktop \
      --replace "Exec=Gittyup" "Exec=gittyup"
  '';

  meta = with lib; {
    description = "A graphical Git client designed to help you understand and manage your source code history";
    homepage = "https://murmele.github.io/Gittyup";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ thiagokokada ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
