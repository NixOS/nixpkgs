# The bad news: the contents of this file are updated by hand because
# the upstream data are in "cmake syntax" for which there does not
# seem to exist a non-executing parser.
#
# The good news: koreader's custom fetch-git-repository scripts will
# check to see if the prefetched copy is at the expected commit or tag
# name.  If it is not, then koreader will attempt to do the fetch over
# the network itself, which will fail in a sandboxed build.
#
# TL;DR: the check (on version bumps) that this file is up-to-date
# is automatic, but the process of making updates is not.
{

  #### vendored tarball repos ##################################

  zlib = rec {
    version = "1.2.11";
    filename = "zlib-${version}.tar.gz";
    url = "http://gentoo.osuosl.org/distfiles/${filename}";
    hash = "sha256-w+Xp/dUATctUL+2l7k8P8HRGKLr47S3V1m+MoRl8saE=";
  };
  sqlite = rec {
    filename = "sqlite-autoconf-3380200.tar.gz";
    url = "https://www.sqlite.org/2022/${filename}";
    hash = "sha256-55dKoUMLrWkKXp95pu5chJKtqCadxnWHWtD7dH18raQ=";
  };
  dropbear = rec {
    version = "2018.76";
    filename = "dropbear_${version}.orig.tar.bz2";
    url = "http://deb.debian.org/debian/pool/main/d/dropbear/${filename}";
    hash = "sha256-8vuRZ+yoz5NFal/B1Pr3CZAqOrcN1E41LzrLw//a6mU=";
  };
  gettext = rec {
    version = "0.21";
    filename = "gettext-${version}.tar.gz";
    url = "http://ftpmirror.gnu.org/gettext/${filename}";
    hash = "sha256-x30NoxAq7JwH9DZx5gYR6/+JqZbvFZSXzo5Z0HV4axI=";
  };
  libffi = rec {
    version = "3.3";
    filename = "libffi-${version}.tar.gz";
    url = "https://sourceware.org/pub/libffi/${filename}";
    hash = "sha256-cvunkicD3fp6Ao1ROsFahcjVTI1n9V+lpIAohdxlIFY=";
  };

  #### vendored git repos #######################################

  curl = {
    url = "https://github.com/curl/curl.git";
    tag = "curl-7_80_0";
    hash = "sha256-kzozc0Io+1f4UMivSV2IhzJDQXmad4wNhXN/Y2Lsg3Q=";
  };
  czmq = {
    url = "https://github.com/zeromq/czmq.git";
    rev = "2a0ddbc4b2dde623220d7f4980ddd60e910cfa78";
    hash = "sha256-p4Cl2PLVgRQ0S4qr3VClJXjvAd2LUBU9oRUvOCfVnyw=";
  };
  djvulibre = {
    url = "https://gitlab.com/koreader/djvulibre.git";
    tag = "release.3.5.28";
    hash = "sha256-J/FuNKAgBtpQHPywNVdQ1d44LRMUQJw3pK8+Ml2Ai+0=";
  };
  fbink = {
    url = "https://github.com/NiLuJe/FBInk.git";
    rev = "b7a81463502c8a445e85edd8e1903dca0ede7f5f";
    hash = "sha256-eBb3Gm6QdkEKR5b+2NSsS7IXSM37yA1CRv4U0GpeI2c=";
  };
  freetype2 = {
    url = "https://gitlab.com/koreader/freetype2.git";
    tag = "VER-2-11-1";
    hash = "sha256-UEn5Renp7EK9hTNRLiV7sec70zvY8mrLRwJoZ6aUJEE=";
  };
  fribidi = {
    url = "https://github.com/fribidi/fribidi.git";
    tag = "v1.0.11";
    hash = "sha256-2y4oN02X88JG2h7366owwcYVkMJJFntgMDcNNmYYTGg=";
  };
  giflib = {
    url = "https://gitlab.com/koreader/giflib.git";
    tag = "5.1.4";
    hash = "sha256-znbY4tliXHXVLBd8sTKrbglOdCUb7xhcCQsDDWcQfhw=";
  };
  glib = {
    url = "https://github.com/GNOME/glib.git";
    tag = "2.58.3";
    hash = "sha256-KmJXCJ6h2QhPyK1axk+Y9+yJzO0wnCczcogopxGShJc=";
  };
  harfbuzz = {
    url = "https://github.com/harfbuzz/harfbuzz.git";
    tag = "3.0.0";
    hash = "sha256-yRRr4RcnbwoZ1Hn3+zbbocKFyBSLYx/exaAHNGsPINA=";
  };
  kobo-usbms = {
    url = "https://github.com/koreader/KoboUSBMS.git";
    tag = "v1.3.1";
    hash = "sha256-u2q4+yIL6fCnhk3jTyxc+Ihcjvt8v7n69E5CiGF4s5Q=";
  };
  leptonica = {
    url = "https://github.com/DanBloomberg/leptonica.git";
    tag = "1.74.1";
    hash = "sha256-SDXKam768xvZZvTbXe3sssvZyeLEEiY97Vrzx8hoc6g=";
  };
  libjpeg-turbo = {
    url = "https://github.com/libjpeg-turbo/libjpeg-turbo.git";
    tag = "2.1.2";
    hash = "sha256-npiO8l+9uXdFvgThgMKij6K3O4RPuQt2dXcFbA1AszM=";
  };
  libk2pdfopt = {
    url = "https://github.com/koreader/libk2pdfopt.git";
    rev = "24b7e6bc136667c98feaa1b519a99dd880b05ebe";
    hash = "sha256-hwyucSELK8xOh0s6qj85FVmbn7IHEb/g/48qiLqKElY=";
  };
  libpng = {
    url = "https://github.com/glennrp/libpng.git";
    tag = "v1.6.37";
    hash = "sha256-O/NsIIhjvJpp1Nl+Pj1GLJkR+nBqu+ymY5vcy/IU0GE=";
  };
  libunibreak = {
    url = "https://github.com/adah1972/libunibreak.git";
    tag = "libunibreak_4_3";
    hash = "sha256-nd4i0JYVRPIpx2lCBjUEHcBEcpFno/ZtczoyH3SP46U=";
  };
  libzmq = {
    url = "https://github.com/zeromq/libzmq";
    rev = "883e95b22e0bffffa72312ea1fec76199afbe458";
    hash = "sha256-R76EREtHsqcoKxKrgT8gfEf9pIWdLTBXvF9cDvjEf3E=";
  };
  lj-wpaclient = {
    url = "https://github.com/koreader/lj-wpaclient.git";
    rev = "4f95110298b89d80e762215331159657ae36b4ef";
    hash = "sha256-hAd1Bqyg7S7ms50JO4m5RKzW41UHSBiYX/NJ6V4x9iY=";
  };
  lodepng = {
    url = "https://github.com/lvandeve/lodepng.git";
    rev = "5601b8272a6850b7c5d693dd0c0e16da50be8d8d";
    hash = "sha256-dD8QoyOoGov6VENFNTXWRmen4nYYleoZ8+4TpICNSpo=";
  };
  lua-htmlparser = {
    url = "https://github.com/msva/lua-htmlparser";
    rev = "4f6437ebd123c3e552a595fc818fdd952888fff2";
    hash = "sha256-FfAwUlH1/LjNIGNYP8TaToqjgfcY0knoXSRKYMDuggQ=";
  };
  luajit = {
    url = "https://github.com/LuaJIT/LuaJIT";
    rev = "20aea93915a0d31138cb00e17cc15eb849e3b806";
    hash = "sha256-eV/HxLV46xXJgNEF1KKQcyeWdk2LtxUwKRBnNWzd4Cw=";
  };
  lua-rapidjson = {
    url = "https://github.com/xpol/lua-rapidjson";
    rev = "242b40c8eaceb0cc43bcab88309736461cac1234";
    hash = "sha256-y/czEVPtCt4uN1n49Qi7BrgZmkG+SDXlM5D2GvvO2qg=";
  };
  luasec = {
    url = "https://github.com/brunoos/luasec";
    tag = "v1.1.0";
    hash = "sha256-Op5huv75Rw1hqqtEjtadKWffrWv9Lov/gxcUXWOA7BM=";
  };
  luasocket = {
    url = "https://github.com/diegonehab/luasocket";
    rev = "5b18e475f38fcf28429b1cc4b17baee3b9793a62";
    hash = "sha256-yu+AV0u8qrrvlNRefizhUJZsqgR9L64urxu0UAR+cAA=";
  };
  lua-Spore = {
    url = "https://framagit.org/fperrad/lua-Spore";
    tag = "0.3.3";
    hash = "sha256-wb7ykJsndoq0DazHpfXieUcBBptowYqD/eTTN/EK/6g=";
  };
  minizip = {
    url = "https://github.com/nmoinvaz/minizip";
    rev = "0b46a2b4ca317b80bc53594688883f7188ac4d08";
    hash = "sha256-P/3MMMGYDqD9NmkYvw/thKpUNa3wNOSlBBjANHSonAg=";
  };
  mupdf = {
    url = "https://github.com/ArtifexSoftware/mupdf.git";
    tag = "1.13.0";
    hash = "sha256-pQejRon9fO9A1mhz3oLjBr1j4HveDLcQIWjR1/Rpy5Q=";
  };
  nanosvg = {
    url = "https://github.com/memononen/nanosvg.git";
    rev = "3cdd4a9d788695699799b37d492e45e2c3625790";
    hash = "sha256-8/WT9t5AJCcat3ZYb9VJZwz0Uisb8TqNV2sU2YV6vBE=";
  };
  openssh = {
    url = "https://github.com/openssh/openssh-portable.git";
    tag = "V_8_6_P1";
    hash = "sha256-yjIpSbe5pt9sEV2MZYGztxejg/aBFfKO8ieRvoLN2KA=";
  };
  openssl = {
    url = "https://github.com/openssl/openssl.git";
    tag = "OpenSSL_1_1_1l";
    hash = "sha256-NGk1K/cY3pciooYVTLX8l3eJz7KB2Ojvtds1HAP5mWY=";
  };
  popen-noshell = {
    url = "https://github.com/famzah/popen-noshell.git";
    rev = "e715396a4951ee91c40a98d2824a130f158268bb";
    hash = "sha256-JeBZMsg6ZUGSnyZ4eds4w63gM/L73EsAnLaHOPpL6iM=";
  };
  sdcv = {
    url = "https://github.com/Dushistov/sdcv.git";
    rev = "d054adb37c635ececabc31b147c968a480d1891a";
    hash = "sha256-mJ9LrQ/l0SRmueg+IfGnS0NcNheGdOZ2Gl7KMFiK6is=";
  };
  tar = {
    url = "http://ftpmirror.gnu.org/tar/tar-1.34.tar.gz";
    hash = "sha256-A9kIz1doz+a3rViMkhxu0hrKv7K3m3iNEzBFNQdkeu0=";
    filename = "tar-1.34.tar.gz";
  };
  tesseract = {
    url = "https://github.com/tesseract-ocr/tesseract.git";
    rev = "60176fc5ae5e7f6bdef60c926a4b5ea03de2bfa7";
    hash = "sha256-FQvlrJ+Uy7+wtUxBuS5NdoToUwNRhYw2ju8Ya8MLyQw=";
  };
  turbo = {
    url = "https://github.com/kernelsauce/turbo";
    tag = "v2.1.3";
    hash = "sha256-vBRkFdc5a0FIt15HBz3TnqMZ+GGsqjEefnfJEpuVTBs=";
  };
  utf8proc = {
    url = "https://github.com/JuliaStrings/utf8proc.git";
    tag = "v2.6.1";
    hash = "sha256-h6MVgyNFM4t6Ay0m9gAKIE1HF9qlW9Xl0nr+maMyDP8=";
  };
  zstd = {
    url = "https://github.com/facebook/zstd.git";
    tag = "v1.5.0";
    hash = "sha256-R+Y10gd3GE17AJ5zIXGI4tuOdyCikdZXwbkMllAHjEU=";
  };
  zsync2 = {
    url = "https://github.com/NiLuJe/zsync2.git";
    rev = "e618d18f6a7cbf350cededa17ddfe8f76bdf0b5c";
    hash = "sha256-S0vxCON1l6S+NWlnRPfm7R07DVkvkG+6QW5LNvXBlA8=";
  };
}
