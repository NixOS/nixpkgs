{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ldacbt";
  version = "2.0.72";

  src = fetchFromGitHub {
    owner = "open-vela";
    repo = "external_libldac";
    rev = "5b4bf66096ba0d69615efb2422ba3d023c34c2fd";
    hash = "sha256-5jeqTyhSBtYky15Xw1lIbUxeGZMQQQdM/EQUFicyi3Y=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./0001-abr-drop-support-for-dynamic-loading-libldac.patch

    # Darwin doesn’t have `<endian.h>`; use the predefined GCC/Clang
    # macros instead.
    ./make-byte-order-checks-portable.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonBuildType = "release";

  # The upstream build system is tied to AOSP, so we use our own Meson
  # definitions to replace it.
  postPatch = ''
    ln -s ${./meson.build} meson.build

    awk -v want=${finalAttrs.version} '
      /^#define LDACBT_LIB_VER_/ { v = v sep ($3+0); sep = "." }
      END {
        if (v != want) { print "version mismatch: package says " want ", source reports " v > "/dev/stderr"; exit 1 }
        print v
      }
    ' src/ldacBT_api.c > VERSION
  '';

  meta = {
    description = "Sony LDAC Bluetooth decoder library (from AOSP via open-vela)";
    homepage = "https://github.com/open-vela/external_libldac";
    license = lib.licenses.asl20;
    # libldac code detects & #error's out on non-LE byte order
    platforms = lib.platforms.littleEndian;
    maintainers = with lib.maintainers; [ qweered ];
  };
})
