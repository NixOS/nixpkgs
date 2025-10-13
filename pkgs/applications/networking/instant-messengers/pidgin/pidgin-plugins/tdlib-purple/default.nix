{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libwebp,
  pidgin,
  tdlib,
}:

stdenv.mkDerivation rec {
  pname = "tdlib-purple";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "ars3niy";
    repo = "tdlib-purple";
    rev = "v${version}";
    sha256 = "sha256-mrowzTtNLyMc2WwLVIop8Mg2DbyiQs0OPXmJuM9QUnM=";
  };

  patches = [
    # Update to tdlib 1.8.0
    (fetchpatch {
      url = "https://github.com/ars3niy/tdlib-purple/commit/8c87b899ddbec32ec6ab4a34ddf0dc770f97d396.patch";
      hash = "sha256-sysPYPno+wS8mZwQAXtX5eVnhwKAZrtr5gXuddN3mko=";
    })
  ];

  preConfigure = ''
    sed -i -e 's|DESTINATION.*PURPLE_PLUGIN_DIR}|DESTINATION "lib/purple-2|' CMakeLists.txt
    sed -i -e 's|DESTINATION.*PURPLE_DATA_DIR}|DESTINATION "share|' CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libwebp
    pidgin
    tdlib
  ];

  cmakeFlags = [ "-DNoVoip=True" ]; # libtgvoip required

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [ "-U__ARM_NEON__" ]
  );

  meta = with lib; {
    homepage = "https://github.com/ars3niy/tdlib-purple";
    description = "libpurple Telegram plugin using tdlib";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;

    # tdlib-purple is not actively maintained and currently not
    # compatible with recent versions of tdlib
    broken = true;
  };
}
