{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libwebp,
  pidgin,
  tdlib,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "tdlib-purple";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "adrighem";
    repo = "tdlib-purple";
    rev = "tdlib-purple-v${version}";
    sha256 = "";
  };

  preConfigure = ''
    sed -i -e 's|DESTINATION.*PURPLE_PLUGIN_DIR}|DESTINATION "lib/purple-2|' CMakeLists.txt
    sed -i -e 's|DESTINATION.*PURPLE_DATA_DIR}|DESTINATION "share|' CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libwebp
    pidgin
    tdlib
    openssl
  ];

  cmakeFlags = [ "-DNoVoip=True" ]; # libtgvoip required

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [ "-U__ARM_NEON__" ]
  );

  meta = {
    homepage = "https://github.com/adrighem/tdlib-purple";
    description = "libpurple Telegram plugin using tdlib";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
