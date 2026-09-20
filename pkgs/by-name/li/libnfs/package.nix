{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnfs";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    tag = "libnfs-${finalAttrs.version}";
    hash = "sha256-4SHgc8LyIsAKqBt7nfdnuRQzthPjkV08JTDyayFh6ng=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DENABLE_MULTITHREADING=ON"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "NFS client library";
    homepage = "https://github.com/sahlberg/libnfs";
    license = with lib.licenses; [
      lgpl2
      bsd2
      gpl3
    ];
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
  };
})
