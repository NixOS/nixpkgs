{ lib
, config
, stdenv
, fetchurl
, bzip2
, cmake
, curl
, db
, docbook_xml_dtd_45
, docbook_xsl
, doxygen
, dpkg
, gettext
, gnutls
, gtest
, libgcrypt
, libgpg-error
, libseccomp
, libtasn1
, libxslt
, lz4
, p11-kit
, patsh
, perlPackages
, pkg-config
, triehash
, udev
, w3m
, xxHash
, xz
, zstd
, withDocs ? true
, withNLS ? true
, nixStoreDir ? config.nix.storeDir or builtins.storeDir
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apt";
  version = "2.9.16";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/apt/apt_${finalAttrs.version}.tar.xz";
    hash = "sha256-9ncx162Jm4WZBYFPvtO03ic8/rhcGEUEPxR4x1LsnvQ=";
  };

  # cycle detection; lib can't be split
  outputs = [ "out" "dev" "doc" "man" ];

  nativeBuildInputs = [
    cmake
    gtest
    (lib.getBin libxslt)
    patsh
    pkg-config
    triehash
  ];

  buildInputs = [
    bzip2
    curl
    db
    dpkg
    gnutls
    libgcrypt
    libgpg-error
    libseccomp
    libtasn1
    lz4
    p11-kit
    perlPackages.perl
    udev
    xxHash
    xz
    zstd
  ] ++ lib.optionals withDocs [
    docbook_xml_dtd_45
    doxygen
    perlPackages.Po4a
    w3m
  ] ++ lib.optionals withNLS [
    gettext
  ];

  postInstall = ''
    # apt assumes dpkg is installed under the same $BIN_DIR folder on a Debian
    # system (among a few other things), otherwise it will refuse to run with
    # the following error:
    # E: Unable to determine a suitable packaging system type
    ln -s ${lib.getBin dpkg}/bin/dpkg $out/bin/dpkg

    # apt-key is a shell script, as such, we need to specify its dependencies,
    # since $PATH could be controlled by other packages
    patsh -f $out/bin/apt-key -s ${nixStoreDir}
  '';

  patches = [
    # We must specify the config and state dir outside of Nix store to be
    # writable by apt. However, this has the side effect of CMake trying to create
    # folder structure during install phase in those places.
    ./dont-install-outside.patch
  ];

  cmakeFlags = [
    # apt cannot work when those 2 are set to Nix's readonly store
    (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "/etc")
    (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_LOCALSTATEDIR" "/var")
    (lib.cmakeOptionType "filepath" "BERKELEY_INCLUDE_DIRS" "${lib.getDev db}/include")
    (lib.cmakeOptionType "filepath" "DOCBOOK_XSL""${docbook_xsl}/share/xml/docbook-xsl")
    (lib.cmakeOptionType "filepath" "GNUTLS_INCLUDE_DIR" "${lib.getDev gnutls}/include")
    (lib.cmakeFeature "DROOT_GROUP" "root")
    (lib.cmakeBool "USE_NLS" withNLS)
    (lib.cmakeBool "WITH_DOC" withDocs)
  ];

  meta = {
    homepage = "https://salsa.debian.org/apt-team/apt";
    description = "Command-line package management tools used on Debian-based systems";
    changelog = "https://salsa.debian.org/apt-team/apt/-/raw/${finalAttrs.version}/debian/changelog";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "apt";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
