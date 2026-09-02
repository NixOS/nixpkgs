{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catdoc";
  version = "0.95";

  src = fetchurl {
    url = "http://ftp.wagner.pp.ru/pub/catdoc/catdoc-${finalAttrs.version}.tar.gz";
    sha256 = "514a84180352b6bf367c1d2499819dfa82b60d8c45777432fa643a5ed7d80796";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/01-amd64_fixes.patch";
      sha256 = "sha256-aIbtmYm291mo4Sfm1KaucnvmUi9RgbXGexInfOQxxug=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/02-Makefile_fixes.patch";
      sha256 = "sha256-cOeuAdjD707FEdwep+slzmDcjjF1MDm59E3drv+mWd0=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/03-Type_fixes.patch";
      sha256 = "sha256-tu34+p0d21w7vjH7WBusfffish3edObqPplKs90Ms9U=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/04-XLS_parsing_improvements.patch";
      sha256 = "sha256-ePkvLxUE/rA1/iMhX7k2zh91N5zgCgbHo2xlPCVVmCI=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/05-CVE-2017-11110.patch";
      sha256 = "1ljnwvssvzig94hwx8843b88p252ww2lbxh8zybcwr3kwwlcymx7";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/06-Fix_OLENAMELENGTH.patch";
      sha256 = "sha256-p64iQlXlhwRjJ4XGyvju+gTSmSOOxOcv4sgzQXGDYsE=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/0007-Added-guards-against-a-signed-text-length-when-parsi.patch";
      sha256 = "sha256-7N5frjh2ggxBhNqumeLW56D/rxINqoO9PRIfqSVIhNw=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/0008-Added-a-guard-against-a-product-overflow-when-proces.patch";
      sha256 = "sha256-Cfo7muRZfyCvZiJ4s9u7+tZKQtCLj/wSQUPz3MWUg4Y=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-6/debian/patches/0009-Added-guards-against-invalid-sector-sizes-when-tryin.patch";
      sha256 = "sha256-TCU+aixaXQolZ6h0QKO0p/mWj6yTFZqfcwVDsaVGl8Q=";
    })
  ];

  # Remove INSTALL file to avoid `make` misinterpreting it as an up-to-date
  # target on case-insensitive filesystems e.g. Darwin
  preInstall = ''
    rm -v INSTALL
  '';

  configureFlags = [ "--disable-wordview" ];

  meta = {
    description = "MS-Word/Excel/PowerPoint to text converter";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
