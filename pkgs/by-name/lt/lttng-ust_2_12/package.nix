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

stdenv.mkDerivation rec {
  pname = "lttng-ust";
  version = "2.12.2";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${pname}-${version}.tar.bz2";
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

<<<<<<< HEAD
  meta = {
    description = "LTTng Userspace Tracer libraries";
    mainProgram = "lttng-gen-tp";
    homepage = "https://lttng.org/";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "LTTng Userspace Tracer libraries";
    mainProgram = "lttng-gen-tp";
    homepage = "https://lttng.org/";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lgpl21Only
      gpl2Only
      mit
    ];
<<<<<<< HEAD
    platforms = lib.intersectLists lib.platforms.linux liburcu.meta.platforms;
    maintainers = [ lib.maintainers.bjornfor ];
=======
    platforms = lib.intersectLists platforms.linux liburcu.meta.platforms;
    maintainers = [ maintainers.bjornfor ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
