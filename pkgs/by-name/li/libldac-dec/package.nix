{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libldac-dec";
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

  env.NIX_CFLAGS_COMPILE = "-O2 -fPIC -Wall -D_DECODE_ONLY -Iinc -Isrc";

  # Verify finalAttrs.version matches LDACBT_LIB_VER_* in upstream source.
  # Guards against silent version drift when the pinned commit changes.
  preBuild = ''
    awk -v want=${finalAttrs.version} '
      /^#define LDACBT_LIB_VER_/ { v = v sep ($3+0); sep = "." }
      END {
        if (v != want) { print "version mismatch: package says " want ", source reports " v > "/dev/stderr"; exit 1 }
      }
    ' src/ldacBT_api.c
  '';

  # Upstream ships AOSP build files and a gcc/ makefile that only knows
  # about the in-tree layout. Compile and link directly; the entire
  # library is two umbrella translation units.
  buildPhase = ''
    runHook preBuild

    soname=libldacBT_dec.so.${lib.versions.major finalAttrs.version}
    sofile=libldacBT_dec.so.${finalAttrs.version}

    $CC -shared -Wl,-soname,$soname src/ldaclib.c src/ldacBT.c -lm -o $sofile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib $sofile
    ln -s $sofile $out/lib/$soname
    ln -s $sofile $out/lib/libldacBT_dec.so

    install -Dm644 inc/ldacBT.h $dev/include/ldac/ldacBT.h

    mkdir -p $dev/lib/pkgconfig
    cat > $dev/lib/pkgconfig/ldacBT-dec.pc <<EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=$out/lib
    includedir=$dev/include/ldac

    Name: ldacBT-dec
    Description: LDAC Bluetooth decoder
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -lldacBT_dec
    Libs.private: -lm
    Cflags: -I\''${includedir}
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Sony LDAC Bluetooth decoder library (from AOSP via open-vela)";
    homepage = "https://github.com/open-vela/external_libldac";
    license = lib.licenses.asl20;
    # LDAC bitstream format assumes LE; source has endian checks
    platforms = lib.platforms.littleEndian;
    maintainers = with lib.maintainers; [ qweered ];
  };
})
