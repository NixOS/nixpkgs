{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libdrm,
  libglvnd,
  libva,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdrmtap";
  version = "0.5.4";

  src = fetchFromGitHub {
    name = "${finalAttrs.pname}-${finalAttrs.version}-source";
    owner = "rustdesk-org";
    repo = "libdrmtap";
    # Keep in sync with LIBDRMTAP_SHA_PINNED in RustDesk's build.py.
    rev = "5da68a3a368db569716d0d0f11cefacbb11b2290";
    hash = "sha256-d7I0DIoUl1XefJgcwwBDI3aSFt0tfdU4SvVBEAHYCYM=";
  };

  outputs = [
    "out"
    "dev"
    "static"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libdrm
    libglvnd
    libva
  ];

  postPatch = ''
    # Keep GPU libraries loaded lazily, with paths that work on NixOS.
    substituteInPlace src/gpu_egl.c \
      --replace-fail '"libEGL.so.1"' '"${lib.getLib libglvnd}/lib/libEGL.so.1"' \
      --replace-fail '"libEGL.so"' '"${lib.getLib libglvnd}/lib/libEGL.so"' \
      --replace-fail '"libGLESv2.so.2"' '"${lib.getLib libglvnd}/lib/libGLESv2.so.2"' \
      --replace-fail '"libGLESv2.so"' '"${lib.getLib libglvnd}/lib/libGLESv2.so"'
  '';

  mesonFlags = [
    # RustDesk loads the library in its own service and does not use the helper.
    (lib.mesonEnable "helper" false)
    (lib.mesonEnable "egl" true)
  ];

  doCheck = true;
  # Integration tests require a DRM device.
  mesonCheckFlags = [
    "--suite"
    "unit"
  ];

  postInstall = ''
    moveToOutput lib/libdrmtap.a "$static"
  '';

  meta = {
    description = "DRM/KMS screen capture library for Linux";
    homepage = "https://github.com/rustdesk-org/libdrmtap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ telometto ];
    platforms = lib.platforms.linux;
  };
})
