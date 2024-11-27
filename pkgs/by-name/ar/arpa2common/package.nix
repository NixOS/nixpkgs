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
  openssl,
  pkg-config,
  ragel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arpa2common";
  version = "2.6.2";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "arpa2common";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eWfWaO6URCK2FWQ+NYAoeCONkovgsVDPSRQVCGFnW3s=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/arpa2/arpa2common/-/commit/13ea82df60b87a5367db00a8c6f3502e8ecb7298.patch";
      hash = "sha256-V9Dhr6PeArqXnuXmFuDjcirlGl7xovq7VQZsrbbMFSk=";
    })
  ];

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
    openssl
    ragel
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
