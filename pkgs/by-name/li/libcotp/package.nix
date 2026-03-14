{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libgcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcotp";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = "libcotp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/oZ/y0HzA1YAYIr9s306XafpyGoVmz8lTXesRScBv1w=";
  };

  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace CMakeLists.txt \
      --replace "add_link_options(-Wl," "# add_link_options(-Wl,"
  '';

  buildInputs = [ libgcrypt ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "C library that generates TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/libcotp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alexbakker ];
    platforms = lib.platforms.all;
  };
})
