{
  lib,
  stdenv,
  fetchFromGitHub,
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
  xen-slim,
}:

stdenv.mkDerivation rec {
  pname = "libvmi";
  version = "0.14.0-unstable-2024-07-25";
  libVersion = "0.0.15";

  outputs = [
    "out" # Contains binaries helpful for testing the libraries. Must be run on the host system.
    "lib" # Contains the LibVMI libraries. This is most likely what you want.
    "dev" # Development headers and the pkg-config spec.
  ];

  src = fetchFromGitHub {
    owner = "libvmi";
    repo = "libvmi";
    rev = "2d7258b5ab2cddea8d0889303d5f2f6f07b125b9";
    hash = "sha256-gTNZEESHtC5K1pM9cznI3OHfq7Fg0LRrSBHybM+DTqs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    bison
    flex
    pkg-config
  ];

  buildInputs =
    [
      glib
      json_c
      libvirt
    ]
    ++ (lib.lists.optional xenSupport xen-slim)
    ++ (lib.lists.optional (!legacyKVM) libkvmi)
    ++ (lib.lists.optional withVMIFS fuse);

  configureFlags =
    lib.lists.optional (!xenSupport) "--disable-xen"
    ++ (lib.lists.optional legacyKVM "--enable-kvm-legacy")
    ++ (lib.lists.optional withVMIFS "--enable-vmifs");

  # libvmi uses dlopen() for the xen libraries, however autoPatchelfHook doesn't work here
  postFixup = lib.strings.optionalString xenSupport ''
    libvmi="$lib/lib/libvmi.so.${libVersion}"
    oldrpath=$(patchelf --print-rpath "$libvmi")
    patchelf --set-rpath "$oldrpath:${lib.makeLibraryPath [ xen-slim ]}" "$libvmi"
  '';

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
    platforms = lib.lists.intersectLists lib.platforms.linux lib.platforms.x86_64;
    maintainers = [ lib.maintainers.sigmasquadron ];
    outputsToInstall = [
      "out"
      "lib"
    ];
  };
}
