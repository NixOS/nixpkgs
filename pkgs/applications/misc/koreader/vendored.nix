# The contents of this file are updated manually, by hand, since the
# upstream data are in "cmake syntax" which does not appear to have a
# parser other than cmake itself.  That's the bad news.
#
# The good news is that koreader's custom fetch-git-repository scripts
# will check to see if the prefetched copy is at the expected commit
# or tag name.  If it is not, then koreader will attempt to do the
# fetch over the network itself, which will fail in a sandboxed build.
#
# So: although the updating of this list is not automated, the check
# (on version bumps) that it is up-to-date *is* automatic.
{
  # vendored tarball repos
  zlib = {
    url = "http://gentoo.osuosl.org/distfiles/zlib-1.2.11.tar.gz";
    hash = "sha256-w+Xp/dUATctUL+2l7k8P8HRGKLr47S3V1m+MoRl8saE=";
    filename = "zlib-1.2.11.tar.gz";
  };
  sqlite = {
    url = "https://www.sqlite.org/2022/sqlite-autoconf-3380200.tar.gz";
    hash = "sha256-55dKoUMLrWkKXp95pu5chJKtqCadxnWHWtD7dH18raQ=";
    filename = "sqlite-autoconf-3380200.tar.gz";
  };
  dropbear = {
    url = "http://deb.debian.org/debian/pool/main/d/dropbear/dropbear_2018.76.orig.tar.bz2";
    hash = "sha256-8vuRZ+yoz5NFal/B1Pr3CZAqOrcN1E41LzrLw//a6mU=";
    filename = "dropbear_2018.76.orig.tar.bz2";
  };
  gettext = {
    url = "http://ftpmirror.gnu.org/gettext/gettext-0.21.tar.gz";
    hash = "sha256-x30NoxAq7JwH9DZx5gYR6/+JqZbvFZSXzo5Z0HV4axI=";
    filename = "gettext-0.21.tar.gz";
  };

  # vendored git repos
  curl = {
    url = "https://github.com/curl/curl.git";
    tag = "curl-7_80_0";
    hash = "sha256-JTgazRsPm4F8RIs38wPq/lC/xhkdzMFuYb65WE94u3Q=";
  };
  czmq = {
    url = "https://github.com/zeromq/czmq.git";
    rev = "2a0ddbc4b2dde623220d7f4980ddd60e910cfa78";
    hash = "sha256-njdKRMc9a7gL1hwG6cs/bZqCqtc59NRAud4UKedRvRo=";
  };
  djvulibre = {
    url = "https://gitlab.com/koreader/djvulibre.git";
    tag = "release.3.5.28";
    hash = "sha256-zN6YfF4yFS+HhJMgnDsz+KYlCUZVinq16TUwHT+TSeE=";
  };
  fbink = {
    url = "https://github.com/NiLuJe/FBInk.git";
    rev = "b7a81463502c8a445e85edd8e1903dca0ede7f5f";
    hash = "sha256-nEDlmY8w/jgJvM+9uOYvbhbTlFKBQ7iWTSAA8U7nt2M=";
  };
  freetype2 = {
    url = "https://gitlab.com/koreader/freetype2.git";
    tag = "VER-2-11-1";
    hash = "sha256-fmwVVMBJeuSJJHhNi3kA5F2Hn2GEdjIoA+ftv0k4ta0=";
  };
  fribidi = {
    url = "https://github.com/fribidi/fribidi.git";
    tag = "v1.0.11";
    hash = "sha256-XxeKQxERM0cSmjTi0GkeouVumW8tvgEp3eS9YkcINus=";
  };
  giflib = {
    url = "https://gitlab.com/koreader/giflib.git";
    tag = "5.1.4";
    hash = "sha256-gj6kzvhdReEkQ4sOQ/QCf+q/NX4Agyq3oRG3OEqU9Yg=";
  };
  glib = {
    url = "https://github.com/GNOME/glib.git";
    tag = "2.58.3";
    hash = "sha256-hP7bk2YnWGIWaPRxpiNs3iPsapBejtodfDzjJe5Lu5M=";
  };
  harfbuzz = {
    url = "https://github.com/harfbuzz/harfbuzz.git";
    tag = "3.0.0";
    hash = "sha256-vW9OSgjRc0pd0CVwab3+9fiCw/CXfqjaZ3//Sucxceo=";
  };
  kobo-usbms = {
    url = "https://github.com/koreader/KoboUSBMS.git";
    tag = "v1.3.1";
    hash = "sha256-klwrjW6ESbgcytGEF3RwQJbJMXejCw6dtEWO39hm/uA=";
  };
  leptonica = {
    url = "https://github.com/DanBloomberg/leptonica.git";
    tag = "1.74.1";
    hash = "sha256-ZOXQT5G2TuCcEubI6Gxj4Eur9GwRx5mMVYwLGiuuypA=";
  };
  libjpeg-turbo = {
    url = "https://github.com/libjpeg-turbo/libjpeg-turbo.git";
    tag = "2.1.2";
    hash = "sha256-EjF3SHtMUjnlGpMbc15Q2VZGwUpIDUk/D9XZRrz8i88=";
  };
  libk2pdfopt = {
    url = "https://github.com/koreader/libk2pdfopt.git";
    rev = "24b7e6bc136667c98feaa1b519a99dd880b05ebe";
    hash = "sha256-Yf09fkMBtncvbN7ZJRoTTN/H+n+W2+mNAk0qfe1Bjws=";
  };
  libpng = {
    url = "https://github.com/glennrp/libpng.git";
    tag = "v1.6.37";
    hash = "sha256-Y4kqabOlWolGSjRnNdrWAp2ZYXeJM5IPL2zeYgjgzHk=";
  };
  libunibreak = {
    url = "https://github.com/adah1972/libunibreak.git";
    tag = "libunibreak_4_3";
    hash = "sha256-SO8pq9HORjWMwnSCeawz4CgTtIidEwWCXlxXwK761vM=";
  };
  libzmq = {
    url = "https://github.com/zeromq/libzmq";
    rev = "883e95b22e0bffffa72312ea1fec76199afbe458";
    hash = "sha256-DIoduffXly4En235SWXn7efKwOzOmijZH4s1G1VMZNw=";
  };
  lj-wpaclient = {
    url = "https://github.com/koreader/lj-wpaclient.git";
    rev = "4f95110298b89d80e762215331159657ae36b4ef";
    hash = "sha256-8W2FAmy3OON6qTJ+kHeCTWpvGrk79rvXjDH+MREBl0Q=";
  };
  lodepng = {
    url = "https://github.com/lvandeve/lodepng.git";
    rev = "5601b8272a6850b7c5d693dd0c0e16da50be8d8d";
    hash = "sha256-5Rv8Oa10LmlbFKrat9grWk4cwRVmdj8Dt6IrKnrjxpI=";
  };
  lua-htmlparser = {
    url = "https://github.com/msva/lua-htmlparser";
    rev = "4f6437ebd123c3e552a595fc818fdd952888fff2";
    hash = "sha256-OoJQRT08191w6w7yiqd6vALGn2aac6d5U2WkmZdM730=";
  };
  luajit = {
    url = "https://github.com/LuaJIT/LuaJIT";
    rev = "20aea93915a0d31138cb00e17cc15eb849e3b806";
    hash = "sha256-ijUHj6aBi2gOfnVe4MqBVUrv+qURxrYGgoeNJvRNvT4=";
  };
  lua-rapidjson = {
    url = "https://github.com/xpol/lua-rapidjson";
    rev = "242b40c8eaceb0cc43bcab88309736461cac1234";
    hash = "sha256-eRErWXxU2r7Clvy+DS2huwcGf9Y+7BfVFy/djJjpOVo=";
  };
  luasec = {
    url = "https://github.com/brunoos/luasec";
    tag = "v1.1.0";
    hash = "sha256-qduxVKL/jaacspAuiEkLFlcJ42gp/DLuLZ7I24ObLTY=";
  };
  luasocket = {
    url = "https://github.com/diegonehab/luasocket";
    rev = "5b18e475f38fcf28429b1cc4b17baee3b9793a62";
    hash = "sha256-oU1yoYGgiVLGTL/5ObOBGEHIxrxyrdEkhSAVqVj1z5w=";
  };
  lua-Spore = {
    url = "https://framagit.org/fperrad/lua-Spore";
    tag = "0.3.3";
    hash = "sha256-lk9xThweQvqp3KiW4932osh+UpuG15F/gkrMsxikDUU=";
  };
  minizip = {
    url = "https://github.com/nmoinvaz/minizip";
    rev = "0b46a2b4ca317b80bc53594688883f7188ac4d08";
    hash = "sha256-X99bVbX4b04DrTgikhDVp2vjJPc6WFhvcf9245Ce0IA=";
  };
  mupdf = {
    url = "https://github.com/ArtifexSoftware/mupdf.git";
    tag = "1.13.0";
    hash = "sha256-EmlIj5ht9sauspug7LlcDtxvBtT69d8szW5NCohVz3c=";
  };
  nanosvg = {
    url = "https://github.com/memononen/nanosvg.git";
    rev = "3cdd4a9d788695699799b37d492e45e2c3625790";
    hash = "sha256-Y5oRLkuGZw53ed6KJ0od+R0ay1BvG8e0GdVy1oU7qFM=";
  };
  openssh = {
    url = "https://github.com/openssh/openssh-portable.git";
    tag = "V_8_6_P1";
    hash = "sha256-7GeprBVc1fodsjY6BGn3YE8Qd/N20/dznlo+G5t7kFc=";
  };
  openssl = {
    url = "https://github.com/openssl/openssl.git";
    tag = "OpenSSL_1_1_1l";
    hash = "sha256-kP+Ef9rYgbbgAUP6bDcQXSWcxsvYDuOsF26SP7dzrS4=";
  };
  popen-noshell = {
    url = "https://github.com/famzah/popen-noshell.git";
    rev = "e715396a4951ee91c40a98d2824a130f158268bb";
    hash = "sha256-pOxrnT2S/yIPLa8ddQmOAs/yK625644WpohEDie9zlU=";
  };
  sdcv = {
    url = "https://github.com/Dushistov/sdcv.git";
    rev = "d054adb37c635ececabc31b147c968a480d1891a";
    hash = "sha256-lwAP9l3Vg3J9wiXt/hv5aBmkq2DlQT1GIGks3muGOfw=";
  };
  tar = {
    url = "https://git.savannah.gnu.org/git/tar.git";
    tag = "release_1_32";
    hash = "sha256-BB/UWRRh8azh9K9LO8lADth4zN+l9zRfsvlCDTCz620=";
  };
  tesseract = {
    url = "https://github.com/tesseract-ocr/tesseract.git";
    rev = "60176fc5ae5e7f6bdef60c926a4b5ea03de2bfa7";
    hash = "sha256-l1MNpnFpZ4oN5dzZzEpU3jVSKq9NuQA+iynE1ZyzsYk=";
  };
  turbo = {
    url = "https://github.com/kernelsauce/turbo";
    tag = "v2.1.3";
    hash = "sha256-9JQblyePY7kx7KPoFM/A3TDVou+GPOgYjq6szLPN8YA=";
  };
  utf8proc = {
    url = "https://github.com/JuliaStrings/utf8proc.git";
    tag = "v2.6.1";
    hash = "sha256-umtOYRD7hzHyKqPbFwI9DkWOJap7ZEAq6jfVP4Jr6YA=";
  };
  zstd = {
    url = "https://github.com/facebook/zstd.git";
    tag = "v1.5.0";
    hash = "sha256-FpK/zI6FAbdiYyWMAQALGQ3rkMkNWHNo0BmsarcaG5w=";
  };
  zsync2 = {
    url = "https://github.com/NiLuJe/zsync2.git";
    rev = "e618d18f6a7cbf350cededa17ddfe8f76bdf0b5c";
    hash = "sha256-/TDyP2aq7es+1WEEmzv0Fulijr/MWU4cvFZocbh55lY=";
  };
}
