{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
  autoreconfHook,
  autoconf-archive,
  bison,
  flex,
  glib,
  pkg-config,
  json_c,
  libvirt,

  withVMIFS ? true,
  fuse,

  legacyKVM ? false,
  libkvmi,

  xenSupport ? true,
  xen,
}:

let
  pname = "libvmi";
  version = "0.14.0-unstable-2026-01-04";
  libVersion = "0.0.15";

  src = fetchFromGitHub {
    owner = "libvmi";
    repo = "libvmi";
    rev = "82bbee6c378da854d07887048b06dc4ee8e20d6a";
    hash = "sha256-PGILZdVdY3MyfvYW8h4NGeB4XgwL02oKdl4RAR1OkqA=";
  };
in

stdenv.mkDerivation {
  inherit pname version src;

  patches = [
    # Compatibility with GCC 15
    (fetchpatch {
      url = "https://github.com/libvmi/libvmi/commit/9deb49d17e7e675158ed3b19d405792254e22bdf.patch";
      hash = "sha256-stjbHogH6JpCu3hTR+UUJGzUeq1TOWZPc8ocjUA7t/g=";
    })
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    glib
    json_c
    libvirt
  ]
  ++ lib.optionals xenSupport [ xen ]
  ++ lib.optionals (!legacyKVM) [ libkvmi ]
  ++ lib.optionals withVMIFS [ fuse ];

  configureFlags =
    lib.optionals (!xenSupport) [ "--disable-xen" ]
    ++ lib.optionals legacyKVM [ "--enable-kvm-legacy" ]
    ++ lib.optionals withVMIFS [ "--enable-vmifs" ];

  # libvmi uses dlopen() for the xen libraries, however autoPatchelfHook doesn't work here
  postFixup = lib.optionalString xenSupport ''
    libvmi="$lib/lib/libvmi.so.${libVersion}"
    oldrpath=$(patchelf --print-rpath "$libvmi")
    patchelf --set-rpath "$oldrpath:${lib.makeLibraryPath [ xen ]}" "$libvmi"
  '';

  passthru = {
    updateScript = unstableGitUpdater { tagPrefix = "v"; };
    inherit libVersion;
  };

  meta = {
    description = "C library for virtual machine introspection";
    longDescription = ''
      LibVMI is a C library with Python bindings that makes it easy to monitor the low-level
      details of a running virtual machine by viewing its memory, trapping on hardware events,
      and accessing the vCPU registers.
    '';
    homepage = "https://libvmi.com/";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sigmasquadron ];
  };
}
