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

stdenv.mkDerivation (finalAttrs: {
  pname = "tdlib-purple";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "adrighem";
    repo = "tdlib-purple";
    tag = "tdlib-purple-v${finalAttrs.version}";
    hash = "sha256-H7fb/kYSjplrazwMbqQD9uLVUadIsn+O810G4Qhx6Rk=";
  };

  preConfigure = ''
    sed -i -e 's|DESTINATION.*PURPLE_PLUGIN_DIR}|DESTINATION "lib/purple-2|' CMakeLists.txt
    sed -i -e 's|DESTINATION.*PURPLE_DATA_DIR}|DESTINATION "share|' CMakeLists.txt
  '';

  strictDeps = true;

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
    changelog = "https://github.com/adrighem/tdlib-purple/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ highghlow ];
    platforms = lib.platforms.unix;
  };
})
