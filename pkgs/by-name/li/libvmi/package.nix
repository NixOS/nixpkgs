{
  lib,
  stdenv,
  fetchFromGitHub,
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
  xen-slim,
}:

let
  pname = "libvmi";
  version = "0.14.0-unstable-2024-09-04";
  libVersion = "0.0.15";

  src = fetchFromGitHub {
    owner = "libvmi";
    repo = "libvmi";
    rev = "033a0ec5468c29a93888385fd722798a2ca639b7";
    hash = "sha256-NPcOqmTO4EligGsOTfyO6Bc1duyAoMuX85ICVIOWFE8=";
  };
in

stdenv.mkDerivation {
  inherit pname version src;

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

  buildInputs =
    [
      glib
      json_c
      libvirt
    ]
    ++ lib.optionals xenSupport [ xen-slim ]
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
    patchelf --set-rpath "$oldrpath:${lib.makeLibraryPath [ xen-slim ]}" "$libvmi"
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
