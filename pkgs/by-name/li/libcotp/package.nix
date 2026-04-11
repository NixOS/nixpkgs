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
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = "libcotp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5Jjk8uby1QjvU7TraTTTp+29Yh5lzbCvlorfPbGvciM=";
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
