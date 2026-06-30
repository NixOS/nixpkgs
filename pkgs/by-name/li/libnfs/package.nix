{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnfs";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    tag = "libnfs-${finalAttrs.version}";
    hash = "sha256-uD7PtW2rcpGVzqD6U0DXK1gUaCKlKh+p+i6CW6jLGdw=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DENABLE_MULTITHREADING=ON"
  ];

  __structuredAtts = true;
  strictDeps = true;
  enableParallelBuilding = true;

  meta = {
    description = "NFS client library";
    homepage = "https://github.com/sahlberg/libnfs";
    license = with lib.licenses; [
      lgpl21Plus # sources and includes
      bsd2 # protocol definitions in *.x files
      gpl3Plus # examples directory (not actually included in the derivation output)
    ];
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
  };
})
