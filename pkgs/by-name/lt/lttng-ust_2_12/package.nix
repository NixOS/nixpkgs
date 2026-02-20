{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  liburcu,
  numactl,
  python3,
}:

# NOTE:
#   ./configure ...
#   [...]
#   LTTng-UST will be built with the following options:
#
#   Java support (JNI): Disabled
#   sdt.h integration:  Disabled
#   [...]
#
# Debian builds with std.h (systemtap).

stdenv.mkDerivation (finalAttrs: {
  pname = "lttng-ust";
  version = "2.12.2";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/lttng-ust-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-vNDwZLbKiMcthOdg6sNHKuXIKEEcY0Q1kivun841n8c=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    numactl
    python3
  ];

  preConfigure = ''
    patchShebangs .
  '';

  hardeningDisable = [ "trivialautovarinit" ];

  configureFlags = [ "--disable-examples" ];

  propagatedBuildInputs = [ liburcu ];

  enableParallelBuilding = true;

  meta = {
    description = "LTTng Userspace Tracer libraries";
    mainProgram = "lttng-gen-tp";
    homepage = "https://lttng.org/";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
      mit
    ];
    platforms = lib.intersectLists lib.platforms.linux liburcu.meta.platforms;
    maintainers = [ lib.maintainers.bjornfor ];
  };

})
