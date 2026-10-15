{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "hidrd";
  version = "0.2.0-unstable-2019-06-03";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DIGImend";
    repo = "hidrd";
    rev = "6c0ed39708a5777ac620f902f39c8a0e03eefe4e";
    hash = "sha256-JK1llvWN8Vzu2YDf/wZJ41F81/034/Big7dmC5bB0OY=";
  };

  patches = [
    # Fix build with gcc15
    #   hex.c:87:35: error: initializer-string for array of 'char' truncates NUL terminator but destination lacks 'nonstring' attribute (17 chars into 16 available) [-Werror=unterminated-string-initialization]
    # https://github.com/DIGImend/hidrd/pull/33
    ./allocate-hex-map-with-the-trailing-null.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "HID report descriptor I/O library and conversion tool";
    homepage = "https://github.com/DIGImend/hidrd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ euxane ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/hidrd.x86_64-darwin
    mainProgram = "hidrd-convert";
  };
}
