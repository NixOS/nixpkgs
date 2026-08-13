{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libjpeg,
  openssl,
  zlib,
  libgcrypt,
  libpng,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,

  enableShared ? !stdenv.hostPlatform.isStatic,
  buildExamples ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvncserver";
  version = "0.9.15";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "libvncserver";
    tag = "LibVNCServer-${finalAttrs.version}";
    hash = "sha256-a3acEjJM+ZA9jaB6qZ/czjIfx/L3j71VjJ6mtlqYcSw=";
  };

  patches = [
    # fix generated pkg-config files
    ./pkgconfig.patch

    (fetchpatch {
      name = "libvncserver-fix-cmake-4.patch";
      url = "https://github.com/LibVNC/libvncserver/commit/e64fa928170f22a2e21b5bbd6d46c8f8e7dd7a96.patch";
      hash = "sha256-AAZ3H34+nLqQggb/sNSx2gIGK96m4zatHX3wpyjNLOA=";
    })

    (fetchpatch {
      name = "CVE-2026-32854.patch";
      url = "https://github.com/LibVNC/libvncserver/commit/dc78dee51a7e270e537a541a17befdf2073f5314.patch";
      hash = "sha256-CgVfvsrgZWnjIzu/0UegoAuCqO7WHhCDVvhH8Yk1cXo=";
    })

    (fetchpatch {
      name = "CVE-2026-32853.patch";
      url = "https://github.com/LibVNC/libvncserver/commit/009008e2f4d5a54dd71f422070df3af7b3dbc931.patch";
      hash = "sha256-ZgpiIS7KoRzDmVLQ0J86wTFFykCBVMt6bZwJsFvIO74=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_SYSTEMD" withSystemd)
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "WITH_EXAMPLES" buildExamples)
    (lib.cmakeBool "WITH_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  # This test checks if using the **installed** headers works.
  # As it doesn't set the include paths correctly, and we have nixpkgs-review to check if
  # packages continue to build, patching it would serve no purpose, so we can just remove the test entirely.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_test(NAME includetest COMMAND' '# add_test(NAME includetest COMMAND'
  '';

  buildInputs = [
    libjpeg
    openssl
    libgcrypt
    libpng
  ]
  ++ lib.optionals withSystemd [
    systemd
  ];

  propagatedBuildInputs = [
    zlib
  ];

  doCheck = enableShared;

  meta = {
    description = "VNC server library";
    homepage = "https://libvnc.github.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
