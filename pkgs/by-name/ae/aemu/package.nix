{ stdenv
, fetchFromGitiles
, cmake
, lib
}:

stdenv.mkDerivation {
  pname = "aemu";
  version = "unstable-2023-08-31";
  src = fetchFromGitiles {
    url = "https://android.googlesource.com/platform/hardware/google/aemu";
    rev = "caf5a079f321b6c60ab7b4bf6e5516378c6a7b37";
    hash = "sha256-JE0w9/1cSXDIfyISxE/CHv35gv1xyNwbrW24rAKAZVs=";
  };
  cmakeFlags = [
    "-DAEMU_COMMON_GEN_PKGCONFIG=ON"
    "-DAEMU_COMMON_BUILD_CONFIG=gfxstream"
  ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Utility library for common functions used in the Android Emulator";
    homepage = "https://android.googlesource.com/platform/hardware/google/aemu";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
