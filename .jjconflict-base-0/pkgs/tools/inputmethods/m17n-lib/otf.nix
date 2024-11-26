{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  autoreconfHook,
  xorg,
  freetype,
}:

stdenv.mkDerivation rec {
  pname = "libotf";
  version = "0.9.16";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/${pname}-${version}.tar.gz";
    sha256 = "0sq6g3xaxw388akws6qrllp3kp2sxgk2dv4j79k6mm52rnihrnv8";
  };

  patches = [
    # https://salsa.debian.org/debian/libotf/-/tree/master/debian/patches
    # Fix cross-compilation
    (fetchpatch {
      url = "https://salsa.debian.org/debian/libotf/-/raw/1be04cedf887720eb8f5efb3594dc2cefd96b1f1/debian/patches/0002-use-pkg-config-not-freetype-config.patch";
      sha256 = "sha256-VV9iGoNWIEie6UiLLTJBD+zxpvj0acgqkcBeAN1V6Kc=";
    })
    # these 2 are required by the above patch
    (fetchpatch {
      url = "https://salsa.debian.org/debian/libotf/-/raw/1be04cedf887720eb8f5efb3594dc2cefd96b1f1/debian/patches/0001-do-not-add-flags-for-required-packages-to-pc-file.patch";
      sha256 = "sha256-3kzqNPAHNVJQ1F4fyifq3AqLdChWli/k7wOq+ha+iDs=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/libotf/-/raw/1be04cedf887720eb8f5efb3594dc2cefd96b1f1/debian/patches/0001-libotf-config-modify-to-support-multi-arch.patch";
      sha256 = "sha256-SUlI87h+MtYWWtrAegzAnSds8JhxZwTJltDcj/se/Qc=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    xorg.libXaw
    freetype
  ];

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $out/bin/libotf-config $dev/bin/
    substituteInPlace $dev/bin/libotf-config \
      --replace "pkg-config" "${pkg-config}/bin/pkg-config"
  '';

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (libotf)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
