{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  pkg-config,
  zlib,
  bzip2,
  xz,
  zstd,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizip-ng";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "minizip-ng";
    rev = finalAttrs.version;
    hash = "sha256-scoEqymRMBTZZVr1fxtKOyBj4VLCgI8jQpanUKrJhiQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    zlib
    bzip2
    xz
    zstd
    openssl
  ];

  cmakeFlags =
    [
      "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
      "-DMZ_OPENSSL=ON"
      "-DMZ_BUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
      "-DMZ_BUILD_UNIT_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
      "-DMZ_LIB_SUFFIX='-ng'"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # missing header file
      "-DMZ_LIBCOMP=OFF"
    ];

  postInstall = ''
    # make lib findable as libminizip-ng even if compat is enabled
    for ext in so dylib a ; do
      if [ -e $out/lib/libminizip.$ext ] && [ ! -e $out/lib/libminizip-ng.$ext ]; then
        ln -s $out/lib/libminizip.$ext $out/lib/libminizip-ng.$ext
      fi
    done
    if [ ! -e $out/include/minizip-ng ]; then
      ln -s $out/include $out/include/minizip-ng
    fi
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeCheckInputs = [ gtest ];
  enableParallelChecking = false;

  meta = with lib; {
    description = "Fork of the popular zip manipulation library found in the zlib distribution";
    homepage = "https://github.com/zlib-ng/minizip-ng";
    license = licenses.zlib;
    maintainers = with maintainers; [
      gebner
      ris
    ];
    platforms = platforms.unix;
  };
})
