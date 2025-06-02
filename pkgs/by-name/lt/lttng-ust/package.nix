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
  version = "2.13.9";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/lttng-ust-${finalAttrs.version}.tar.bz2";
    hash = "sha256-KtbWmlSh2STBikqnojPbEE48wzK83SQOGWv3rb7T9xI=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
  ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ liburcu ];

  buildInputs = [
    numactl
    python3
  ];

  preConfigure = ''
    patchShebangs .
  '';

  hardeningDisable = [ "trivialautovarinit" ];

  configureFlags = [ "--disable-examples" ];

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    description = "LTTng Userspace Tracer libraries";
    mainProgram = "lttng-gen-tp";
    homepage = "https://lttng.org/";
    changelog = "https://github.com/lttng/lttng-ust/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
      mit
    ];
    platforms = lib.intersectLists lib.platforms.linux liburcu.meta.platforms;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
