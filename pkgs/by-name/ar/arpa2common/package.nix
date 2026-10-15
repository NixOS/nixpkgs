{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,

  arpa2cm,
  doxygen,
  e2fsprogs,
  graphviz,
  libsodium,
  lmdb,
  krb5,
  pkg-config,
  ragel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arpa2common";
  version = "2.6.4";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "arpa2common";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qqdc+eYLnYQs2Q7sk0D5Trr1GbRTmV1w4sZiVwFwfMw=";
  };

  postPatch = ''
    sed '1i#include <stddef.h>' -i lib/identity/identity.rl
  '';

  nativeBuildInputs = [
    cmake
    arpa2cm
    doxygen
    graphviz
    pkg-config
  ];

  propagatedBuildInputs = [
    e2fsprogs
    libsodium
    lmdb
    ragel
  ];

  buildInputs = [
    krb5
  ];

  meta = {
    changelog = "https://gitlab.com/arpa2/arpa2common/-/blob/v${finalAttrs.version}/CHANGES";
    description = "ARPA2 ID and ACL libraries and other core data structures for ARPA2";
    longDescription = ''
      The ARPA2 Common Library package offers elementary services that can
      benefit many software packages.  They are designed to be easy to
      include, with a minimum of dependencies.  At the same time, they were
      designed with the InternetWide Architecture in mind, thus helping to
      liberate users.
    '';
    homepage = "https://gitlab.com/arpa2/arpa2common";
    license = with lib.licenses; [
      bsd2
      cc-by-sa-40
      cc0
      isc
    ];
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
  };
})
