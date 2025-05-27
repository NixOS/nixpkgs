{
  lib,
  stdenv,
  hexdump,
  locale,
  fetchurl,
  python3,
  gnupg,
  cmake,
  doxygen,
  gmp,
  graphviz,
  libxml2,
  libxslt,
  perl,
  pkg-config,
  qt6,
  shared-mime-info,
  lmdb,
  databaseLibrary ? lmdb, # can be built with tokyocabinet instead
  highDim ? false, # whether or not to include triangulations of dimension 9-15
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "regina-normal";
  version = "7.4.1";

  # Signed source tarball
  src =
    let
      inherit (finalAttrs) version;
      manifest = fetchurl {
        url = "https://github.com/regina-normal/regina/releases/download/regina-${version}/SHA256SUMS-signed.txt";
        hash = "sha256-uXbyHnmkosMg2/9ikNaN7vKA2IZSxSGg2TdimD/YsXU=";
      };
      publicKey = ./publickey.asc; # Benjamin Burton's PGP key (https://people.debian.org/~bab/regina-key.txt)
    in
    fetchurl {
      url = "https://github.com/regina-normal/regina/releases/download/regina-${version}/regina-${version}.tar.gz";
      hash = "sha256-dBMQFAmbdwg90dCQBP1ryXJCHHktGIzfQ/D9Ecpssu0=";
      nativeBuildInputs = [ gnupg ];
      downloadToTemp = true;
      postFetch = ''
        pushd "$(mktemp -d)" || exit 1
        export GNUPGHOME=$PWD/gnupg
        mkdir -m 700 "$GNUPGHOME"
        ln -s ${manifest} SHA256SUMS-signed.txt
        ln -s "$downloadedFile" regina-${version}.tar.gz
        gpg --import ${publicKey}
        gpg --trust-model always --verify SHA256SUMS-signed.txt
        sha256sum -c --ignore-missing SHA256SUMS-signed.txt
        popd || exit 1
        mv "$downloadedFile" "$out"
      '';
    };

  nativeBuildInputs = [
    cmake
    doxygen
    libxslt
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    databaseLibrary
    gmp
    graphviz
    libxml2
    perl
    python3
    qt6.qtbase
    qt6.qtsvg
    shared-mime-info
  ];

  prePatch = ''
    substituteInPlace python/regina/CMakeLists.txt \
      --replace-fail '$ENV{DESTDIR}''${Python_SITELIB}' "${placeholder "out"}/${python3.sitePackages}"
    patchShebangs utils/testsuite/*.{in,test,sh} python/testsuite/test*.in python/regina-python.in
  '';

  cmakeFlags = [
    "-DREGINA_INSTALL_TYPE=XDG"
    "-DPYLIBDIR=${placeholder "out"}/${python3.sitePackages}"
  ]
  ++ lib.optionals highDim [ "-DHIGHDIM=1" ];

  preFixup = ''
    qtWrapperArgs+=(--set-default REGINA_PYLIBDIR "$out/${python3.sitePackages}")
  '';

  postFixup = ''
    # wrapQtAppsHook ignores files that are non-ELF executables
    wrapProgram $out/bin/regina-python \
      --set-default REGINA_PYLIBDIR $out/${python3.sitePackages}
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    hexdump
    locale
  ];

  installCheckTarget = "test";

  meta = {
    description = "Software for low-dimensional topology";
    mainProgram = "regina-gui";
    homepage = "https://regina-normal.github.io";
    changelog = "https://regina-normal.github.io/#new";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
})
