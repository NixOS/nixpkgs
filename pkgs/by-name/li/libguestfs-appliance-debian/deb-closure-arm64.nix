# This is a generated file.  Do not modify!
# Following are the Debian packages constituting the closure of: base-passwd dpkg libc6-dev perl bash dash gzip bzip2 tar grep mawk sed findutils g++ make curl patch locales coreutils util-linux file dpkg-dev pkg-config login passwd sysvinit diff libguestfs-tools linux-image-arm64 qemu-utils

{ fetchurl }:

[
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/gcc-14-base_14.2.0-17_arm64.deb";
      sha256 = "e0edb75399c798b8bafa6843a7448b36be2b17bc7035db1c0044a8b0a3b05029";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libgcc-s1_14.2.0-17_arm64.deb";
      sha256 = "e08c185dc7415d4d45090982fad5bb58577d4db7ef685d332fc03f9b1a986773";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc6_2.40-7_arm64.deb";
      sha256 = "339dc8a20e37e527448c76ea119d7fd921e0908851ca80322d30a1d7a2127390";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cdebconf/libdebconfclient0_0.277_arm64.deb";
      sha256 = "a1f119c4d0ad50946e7da7e35c1f03c3002db1dbb04982ca263de53ba96a9e49";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pcre2/libpcre2-8-0_10.45-1_arm64.deb";
      sha256 = "1427e605a281d966c55934363362f3aa2ce458ed38a65db3b908b7d1122aa479";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libselinux/libselinux1_3.8-4_arm64.deb";
      sha256 = "9eca3e6d53307052ccb8a28b3a5848c596ce29a56c9d0e4d70cae2493104c821";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/base-passwd/base-passwd_3.6.6_arm64.deb";
      sha256 = "f43fcbf04bf117e50e13e387bd65d72abc6c6c0c93e8d2a7544b41da6e2e9b27";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/acl/libacl1_2.3.2-2+b1_arm64.deb";
      sha256 = "10b2399169e42e6d8db55944116cb2ed61caab997cf700acb83de0b0668e5721";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/t/tar/tar_1.35+dfsg-3.1_arm64.deb";
      sha256 = "c460a8294202ca3802b7c703b0bd70dd8bda1f2fc8785839595cf9d5e060d71b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/bzip2/libbz2-1.0_1.0.8-6_arm64.deb";
      sha256 = "3537fe4fc577a60c8a9568873cd577db7ebc135eb8bb1825f18caf8972d9d2f2";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/x/xz-utils/liblzma5_5.6.4-1_arm64.deb";
      sha256 = "e096978fbafa216f4972a4a1ec3867d2735d8f9fca99d84406acd426eeac5043";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libm/libmd/libmd0_1.1.0-2+b1_arm64.deb";
      sha256 = "772e86842fd3fa1816a0cfee4833a73996aaa550461491543b886b9c8f999052";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libz/libzstd/libzstd1_1.5.6+dfsg-2_arm64.deb";
      sha256 = "dcb29cb750248f27c8249b8efdceb8fd3827e1b52302d417f5f9bca2ebfcc195";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/z/zlib/zlib1g_1.3.dfsg+really1.3.1-1+b1_arm64.deb";
      sha256 = "209aa5cf671e97b9eb0410844fa6df4cae2e75b0c72e7802ab6c8ece13e6ddef";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dpkg/dpkg_1.22.15_arm64.deb";
      sha256 = "01b6de79276db932966590175f0bf36a63e026d6bb51f7556e11ad0ccb48e0d7";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc-dev-bin_2.40-7_arm64.deb";
      sha256 = "cd61a4f194acccace51b4caa9145524e665311ab6c0202d2aabec4f696a73c6a";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/linux/linux-libc-dev_6.12.12-1_all.deb";
      sha256 = "4df2b95ca251c87d736a485c6d27ae1a73c7a4888ae7f7abc9d587b4daf3e485";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxcrypt/libcrypt1_4.4.38-1_arm64.deb";
      sha256 = "b9aaa808aa3812b3de3e54eb5dfb16762c1779db032604abef2354c02fdc29b8";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxcrypt/libcrypt-dev_4.4.38-1_arm64.deb";
      sha256 = "eec6d4658495cdb8ce505cad91e0918edb8086677f280f3851c07ccd70543054";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rpcsvc-proto/rpcsvc-proto_1.4.3-1+b1_arm64.deb";
      sha256 = "6ae3c216e6c7d8e042ad3f122b8aa89aff56b2b5174b1c5780a7841b3becd61c";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc6-dev_2.40-7_arm64.deb";
      sha256 = "9bef03a0c5df75496368af85edda51e3129f363030fc01b8c38418002dad8319";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl/perl-base_5.40.1-2_arm64.deb";
      sha256 = "4311b71d07b3ca713d70fa4f5ef7902bc33b7659b09b7425d040c93ffb6e8094";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl/perl-modules-5.40_5.40.1-2_all.deb";
      sha256 = "9cf0ce4ae1fed57dab7d4e7bb2e3e728d634dc50b2924a1b1274ba2b8ce4f893";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/db5.3/libdb5.3t64_5.3.28+dfsg2-9_arm64.deb";
      sha256 = "bfef56508d69fd3f940668f6abd0a466a362cabf63c4cc1c787cc58d28f6e92f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gdbm/libgdbm6t64_1.24-2_arm64.deb";
      sha256 = "329efe726e24a413b9933e298ce24d255973ec111eea0ca721157968fd24156a";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gdbm/libgdbm-compat4t64_1.24-2_arm64.deb";
      sha256 = "266b9a9e8d1ecc4393ebd29bec7e7c0fe1505b1d8755033af9e15df161316627";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl/libperl5.40_5.40.1-2_arm64.deb";
      sha256 = "acc72d4415abc02bf3ceb68dee1f967d837976e8158eebe4827f47ee40957c27";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl/perl_5.40.1-2_arm64.deb";
      sha256 = "3ada04a565f1e5fecd04ea6c8e7bacba9c13aa7042388288674843d0092687c8";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/original-awk/original-awk_2025-01-16-1_arm64.deb";
      sha256 = "6dac386d90a2c91d026e11011ee0344a7da9132a72512e000ab3e676e8e8361a";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/base-files/base-files_13.6_arm64.deb";
      sha256 = "3c8054ecd64258f6affbe06ba60b648a90b67303f7208fc4225aa618e137d3ce";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/debianutils/debianutils_5.21_arm64.deb";
      sha256 = "7a607fcc1702b4264dcdb8682fb9aaf6cf47af0743b13fd161488cfb195d55e1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ncurses/libtinfo6_6.5+20250216-1_arm64.deb";
      sha256 = "0b8e0ab244962d28a06fa406e657fd3cb19c2fd43ff99a6c801b6b66b0c65bdc";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/bash/bash_5.2.37-1.1_arm64.deb";
      sha256 = "f290d2b7a860155fce899cb6fc2e2b2429125647577e5fb2d7d9a5e875a186b2";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dash/dash_0.5.12-12_arm64.deb";
      sha256 = "ce4c8688a1a3ea510186ba95aba74d4c49863094e47e1effc0b602839e840c04";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gzip/gzip_1.13-1_arm64.deb";
      sha256 = "cd46c9482fd3b96d4ecf282b01185ef9341b0ffcd40816372141f73037ce2c36";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/bzip2/bzip2_1.0.8-6_arm64.deb";
      sha256 = "9fa8514c3fb3f363e7fa8bc85f699aaf15e747afaf220c57b978e9b74fd568bc";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/grep/grep_3.11-4+b1_arm64.deb";
      sha256 = "6f7257fbec0197bd54b2347861ff01e2c4e8411790b0df20242483615324fe66";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mawk/mawk_1.3.4.20250131-1_arm64.deb";
      sha256 = "0ab946ff4b8a34d93f81727957612f290c86cd0db39e849dc0ae5e3f3a9563d6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sed/sed_4.9-2+b1_arm64.deb";
      sha256 = "338be72b4203acd9ee69d10377b800ae131db7b8ef44a4471ef1890d2c99e07c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/findutils/findutils_4.10.0-3_arm64.deb";
      sha256 = "c8b505ce907c293031095b3a237cb231967963b1d5aa8b1699aff45ccec3158a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gmp/libgmp10_6.3.0+dfsg-3_arm64.deb";
      sha256 = "a27bbc27f119161ea9702c8dd66f54131cdf0d2ca73000f50ea91ef2fdfef0fb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/isl/libisl23_0.27-1_arm64.deb";
      sha256 = "21c490db3fa5f0a517c55090a199334da6164589772ebd922dff1e569c78515d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mpfr4/libmpfr6_4.2.1-1+b2_arm64.deb";
      sha256 = "69dac0d1f7e4e0b27b8682f7ddf2ca7ae6c83138d9b25c9d9216479d2143705b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mpclib3/libmpc3_1.3.1-1+b3_arm64.deb";
      sha256 = "d4cfe026a624e51641c80ef2af77387185714f62f3b5c87035e62d9ed8d9eec1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/cpp-14-aarch64-linux-gnu_14.2.0-17_arm64.deb";
      sha256 = "ccc64b5625662fbb0edfd57a3c3985eeab9112f98cc5437bfa1a2d3b99724698";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/cpp-14_14.2.0-17_arm64.deb";
      sha256 = "d8b2e4ef41736c797d2ef906fae6b9c9dc8a5f6bb4ccf98614c8d9dca55e4d6b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/cpp-aarch64-linux-gnu_14.2.0-1_arm64.deb";
      sha256 = "bd9c9f4536a0aea285c4735d2dfedff624f8457b8f1bb3d15ab924e029cd7aff";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/cpp_14.2.0-1_arm64.deb";
      sha256 = "88b702b0fa5942a4ee52c27f1ccf6316b831357e86693b709d216ba43348172e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libstdc++6_14.2.0-17_arm64.deb";
      sha256 = "10560f08b8390d8e9ede9ba008d5f97b44ee8e52df1865147c0476d4e331b472";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libcc1-0_14.2.0-17_arm64.deb";
      sha256 = "542ccd38255ab8e55b6b180fd9303adc8cd4d9fa2fcf7419a9726146dbc3c2c5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/binutils-common_2.44-2_arm64.deb";
      sha256 = "debb3628dbd9bb658ebab1f45425a889db028be916b132f9b40dba3856b44676";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libsframe1_2.44-2_arm64.deb";
      sha256 = "b31f658e11000c6a9af35c38024f356e6892c7657aa98cdbb1145e180a676ae2";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libbinutils_2.44-2_arm64.deb";
      sha256 = "f248ea0b127db1ec6aaedc411148065f7fad90e273cc4fedd78abe4506469b9a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libctf-nobfd0_2.44-2_arm64.deb";
      sha256 = "c665cb8388b0b7a34ef07896536b6697ffb6f53383b496cced4baa2ae3e009e3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libctf0_2.44-2_arm64.deb";
      sha256 = "5442cff2f4381a5769b41615f7b608336ad991e15cb54d53597dced3dd7030b8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/jansson/libjansson4_2.14-2+b3_arm64.deb";
      sha256 = "7938472b1ddfa8b0c8f58d5f44406ae7a77a342dbb502a02f6bf292b4f853ab0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/binutils-aarch64-linux-gnu_2.44-2_arm64.deb";
      sha256 = "60a59917489cc92046b818e464bb260938632b062b1ec6c79e1ee848295af8b1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libgomp1_14.2.0-17_arm64.deb";
      sha256 = "81b585763d2fe9cdb774fbe6db4f03b3bac4bee43a2f8d45b2c6b789abf0b2ce";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libitm1_14.2.0-17_arm64.deb";
      sha256 = "3170b74396d3677b84e636f4eef3bdaf1d7f869f707173237aa09869a6af27c4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libatomic1_14.2.0-17_arm64.deb";
      sha256 = "d3d0c055765e8dd56003904710e1b9c5e666a19e025e95e081738b8663f4dcc4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libasan8_14.2.0-17_arm64.deb";
      sha256 = "e90cd476c6b2c814701718fe60585c16ec693c86a1139e030478fa7993e26585";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/liblsan0_14.2.0-17_arm64.deb";
      sha256 = "819c5a6b61aab8bf689ecc2c6dfafa5ece76dd274d7ee19bbd0436cd7cbfd0cb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libtsan2_14.2.0-17_arm64.deb";
      sha256 = "52686475bd26a629428645762cd45b572bdcc1edf121c156ab15ffd0d4b34c54";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libubsan1_14.2.0-17_arm64.deb";
      sha256 = "f8ce7ed92471af6419f4406bbb0225b7e0a45f94f9e81cae6131b5c219a261a7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libhwasan0_14.2.0-17_arm64.deb";
      sha256 = "ec2be3c30ab71cca4d8d0d49ef3f6e8516939313d073a5f589e025c98b6a0e64";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libgcc-14-dev_14.2.0-17_arm64.deb";
      sha256 = "35a9284197d500941b08a68f435b5cfac7975e486b702806e98b7698449eb77b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/gcc-14-aarch64-linux-gnu_14.2.0-17_arm64.deb";
      sha256 = "5b0f74afbc9dd943e84e5a88d13fc3684f4d6cff21980010de38b42e2d9ce202";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libgprofng0_2.44-2_arm64.deb";
      sha256 = "f45790b43a411cd9794247feebe4358cdc179fe19712f239e4d24f2dd3df847b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/binutils_2.44-2_arm64.deb";
      sha256 = "ec4d9560351c61dbfd05569cc30247bd5b6805014f5752f05e31c6e86445119f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/gcc-14_14.2.0-17_arm64.deb";
      sha256 = "19d60111d4cb72f0b7af52738ed78552c871dc24871adbb62559a57f2aebcc5d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/gcc-aarch64-linux-gnu_14.2.0-1_arm64.deb";
      sha256 = "c8390408ed90cc96d4fead68e313ed5ce147f1654807c23235818d535d2d7d7e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/gcc_14.2.0-1_arm64.deb";
      sha256 = "f543b52e29a6780a78c73cf08e551e8e524d623c1092c477cfd8beb5285a86f5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libstdc++-14-dev_14.2.0-17_arm64.deb";
      sha256 = "766510f2a9c4980fb1c7952230bc6d6e221344fd7a93dbc57b4969d96d38b1c4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/g++-14-aarch64-linux-gnu_14.2.0-17_arm64.deb";
      sha256 = "f937e73dffc912335958b56349880f55bce6f3823f67ad72d7d5375b8b2c44ea";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/g++-14_14.2.0-17_arm64.deb";
      sha256 = "91fae2a24ee96db428bfd77ab308a1c45b9de7205f2d3459c382b759e1aae759";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/g++-aarch64-linux-gnu_14.2.0-1_arm64.deb";
      sha256 = "655d9a7cb70b0342f5f1bf4f2a7b0241df15d49ab9a2567445c785b7592122f9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/g++_14.2.0-1_arm64.deb";
      sha256 = "e4b8f8fae7c838c40b9db29251b152c9af03a4d4463388d69efdda66c4e97e79";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/make-dfsg/make_4.4.1-1_arm64.deb";
      sha256 = "e3c149f3c9699497d81ad637b0c8a794d833439d40fec7a6ca4b0d0dd71683fb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/brotli/libbrotli1_1.1.0-2+b7_arm64.deb";
      sha256 = "10270398c4842e71c72b4081fa1761728b3225d6c8dce7c58d5baafe58a5e18f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nettle/libnettle8t64_3.10.1-1_arm64.deb";
      sha256 = "16107ce5a7b522da021fa8aba42d42af9c5e90ddabfcda3710aff6ea95808ee0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nettle/libhogweed6t64_3.10.1-1_arm64.deb";
      sha256 = "cb92d5a51c4fd6c7b7cbb62aaa60c7af830d0bea5b410fb1f47ee685e26944d1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libu/libunistring/libunistring5_1.3-1_arm64.deb";
      sha256 = "63756a9d18cbe33212831cfbe92e9fcb2394138850e8e3627ef601675bc6b3d6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libi/libidn2/libidn2-0_2.3.7-2+b1_arm64.deb";
      sha256 = "b6ba47e886f6ca2c4b86626393d72f4e296a4573f8321694412f8ca8bc784488";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libf/libffi/libffi8_3.4.7-1_arm64.deb";
      sha256 = "928b165e952e3e6da226ce4db4a0169a017edb38405049e4c19f2ba02f5d1481";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/p11-kit/libp11-kit0_0.25.5-3_arm64.deb";
      sha256 = "78bfc746e68a5217e845f488f69100ed89d10c8886fbd3ffce937acb6a7d88fb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libt/libtasn1-6/libtasn1-6_4.20.0-2_arm64.deb";
      sha256 = "94fdbc4861998837a1e7fd9e40b1883c3647705566126e89c51304c1f9e3ec69";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gnutls28/libgnutls30t64_3.8.9-2_arm64.deb";
      sha256 = "e6b2b2f56bae22b6d6b8d35cb7359122901f0bb232cbbe15f59e765a3d7a45f1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/krb5/libkrb5support0_1.21.3-4_arm64.deb";
      sha256 = "e7e63559701e4b8d5e2bafa5122d0687741d58e1974c7281273f28ff5986065b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/libcom-err2_1.47.2-1_arm64.deb";
      sha256 = "77f72a4aa97374667c5181a2f31216df822d2bc159adc57ee04a42ca402055cd";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/krb5/libk5crypto3_1.21.3-4_arm64.deb";
      sha256 = "c236c66d10f223cb6c137f207f426c0c0665dd5055df0151f5a181ef5bab5981";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/keyutils/libkeyutils1_1.6.3-4_arm64.deb";
      sha256 = "147e7da822c5f313bc22dbd5484036491ea6f77ef8dd40d3f66af09873ae3729";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openssl/openssl-provider-legacy_3.4.1-1_arm64.deb";
      sha256 = "9e7e3d095c28d082658ba3bff15696b72fca119f3ec6dde0f9fbbe3475bc16e0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openssl/libssl3t64_3.4.1-1_arm64.deb";
      sha256 = "a34dbe7dc52eb0372f2079f3daafdfa53c4e2cf54583bcae0f229ef8970a697f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/krb5/libkrb5-3_1.21.3-4_arm64.deb";
      sha256 = "8a0a680d2912650d0f526a298a8ed9b4d3df04edfe2a8d923cd522da4e296f6c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/krb5/libgssapi-krb5-2_1.21.3-4_arm64.deb";
      sha256 = "049a80866f055394812a863bf9ae19081e75a4dfe2144f80127b56c8d1ee5b4c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cyrus-sasl2/libsasl2-modules-db_2.1.28+dfsg1-9_arm64.deb";
      sha256 = "ed6eb05f8ded71ab16a0369845805b373fc8a71c0e7d33f73fa2fb11e83a1977";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cyrus-sasl2/libsasl2-2_2.1.28+dfsg1-9_arm64.deb";
      sha256 = "6431628c62524c8397255c1c4a7c7ef63661b801f3be9a59ad41e7a2e46e6210";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openldap/libldap2_2.6.9+dfsg-1_arm64.deb";
      sha256 = "caf800e8eb36c32a1fe2e774a4ab5dd4c44d3766b64fc59f3e1cbcc5d57bbdc7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nghttp2/libnghttp2-14_1.64.0-1_arm64.deb";
      sha256 = "fede311b0cbdf4c674f81e52b17f7eb5b9ff2ecda365de175882febd80535b8f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nghttp3/libnghttp3-9_1.6.0-2_arm64.deb";
      sha256 = "14861f00c2987418c39547c6e522f1847a4a041f39c6e9618ebed9a34a96bf9a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ngtcp2/libngtcp2-16_1.9.1-1_arm64.deb";
      sha256 = "60651a257c852a59f3b86086b02fae07d888a52579e5033ed4fa0f9a82d4cef0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ngtcp2/libngtcp2-crypto-gnutls8_1.9.1-1_arm64.deb";
      sha256 = "6a3edfb474e8a35b55e04aeff712c0db9b2b4b74bc556cb5fd970fb6022e51e7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libp/libpsl/libpsl5t64_0.21.2-1.1+b1_arm64.deb";
      sha256 = "7ea03d8a7d16edce7b1b1e94980c058c0f1fb3c595eb9154b0e8590d0e7f75af";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rtmpdump/librtmp1_2.4+20151223.gitfa8646d.1-2+b5_arm64.deb";
      sha256 = "20d52d20c4834158e956ae8e1d42a61d22330062052116d5422daa2d3b1d433b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libssh2/libssh2-1t64_1.11.1-1_arm64.deb";
      sha256 = "c4eefd2ef53766d4cebbdae42cba1cc46e4e4f1b818b45877c832633f3235062";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/curl/libcurl3t64-gnutls_8.12.1-3_arm64.deb";
      sha256 = "f6f0520e49ab99df102ad53501e354522a1ade31f0cefcac7589e3a026efa4f0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/curl/curl_8.12.1-3_arm64.deb";
      sha256 = "d2a7dab6463759f982a3b495d44809256759d385faab0c1bb391f8caf494d8b0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/patch/patch_2.7.6-7+b1_arm64.deb";
      sha256 = "7d53a81cbd4d1862bd7ccac7c8d65dcd46a4b3d8b2d528619846f6245e652749";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc-bin_2.40-7_arm64.deb";
      sha256 = "04bf5b013aa72406a318751d6c00d99836f56edf936b29f57d7e36b1c6fe0e01";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc-l10n_2.40-7_all.deb";
      sha256 = "fd0f6e1d75c5c2f71bdbc94fc73382f3cdd673addaf885476a0757b95a13b0c9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/debconf/debconf_1.5.89_all.deb";
      sha256 = "3b7529580fae9a804999861ceb802c17a65cb734de2558e8423f9a449ac22e2c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/locales_2.40-7_all.deb";
      sha256 = "753f1fbc436fa2d03aec87f76a8ebbd3ac55ee94de892c9b6f0b191b44aeb541";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/attr/libattr1_2.5.2-3_arm64.deb";
      sha256 = "25057d7bfba969a76cdf18ae88ce7ff6e664520726ddf02cdde97c03d5e9a43c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/coreutils/coreutils_9.5-1+b1_arm64.deb";
      sha256 = "b7fcf35a87b68577f2902e527d93a1b17e21a6f0dcc16f12e6adba73f0d1fc77";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/audit/libaudit-common_4.0.2-2_all.deb";
      sha256 = "b6edcd7aa36a2a5a1abd2c52966d69a99eebdb69c8f5cb33cbf415b0875775e3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcap-ng/libcap-ng0_0.8.5-4+b1_arm64.deb";
      sha256 = "eb6da83296e4710a8600c1426692ed9b9eadcab7ebd36dbabc2a562b5c1ab691";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/audit/libaudit1_4.0.2-2+b2_arm64.deb";
      sha256 = "a1124818a702c584ee139948c20596f6bb464d8110a14bc2dc748646ae461cab";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pam/libpam0g_1.7.0-3_arm64.deb";
      sha256 = "0a6cb41c7c6e6357df28716d8160239d44524e3893b4407cb6ca4060f648de6d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcap2/libcap2_2.66-5+b1_arm64.deb";
      sha256 = "71c4343142a26e7fffd49a9fe8f405f3ac60679f431789bb321ba0239b7b1db6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/libsystemd0_257.3-1_arm64.deb";
      sha256 = "20e3df16a006d55d88d2620459275040759d6d9545699a3d51ac8071f1e63568";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pam/libpam-modules-bin_1.7.0-3_arm64.deb";
      sha256 = "37595f59046790bba47e007c78876efe3366404c80b6a61aec03fe924d1f5d64";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pam/libpam-modules_1.7.0-3_arm64.deb";
      sha256 = "1f6c3366f3b8a31d708e258275d75367ac65b6747e13533920ada7e2eed53415";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pam/libpam-runtime_1.7.0-3_all.deb";
      sha256 = "0f19f338c735e2ba51d9448e2dcba195d9698c5829dc864aec9b3b8913bb6f69";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libblkid1_2.40.4-5_arm64.deb";
      sha256 = "5aa5cf3b396910a3fd1936ee45652ec7aac612601a88276f279ee210d7934257";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libmount1_2.40.4-5_arm64.deb";
      sha256 = "cdfe4b68a14a5a6c615df8513c9eab4fa758c80b44b7ce93a7c7130c643fcc79";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libsmartcols1_2.40.4-5_arm64.deb";
      sha256 = "54c3be481b631a83de81f694aeb01698339962aad8be2186c63e71919269cdee";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/libudev1_257.3-1_arm64.deb";
      sha256 = "946fad8705479e0c2b2aed450fb21dcd31b0d8ab48ef5a49b981325acd7a9326";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libuuid1_2.40.4-5_arm64.deb";
      sha256 = "a96f7ce91c66ccd474871eea85bc401d92e2ace94c1a633bb54ebf96402c2463";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/util-linux_2.40.4-5_arm64.deb";
      sha256 = "a65334a124058844b491241454cfa7df21dd397b21ef0f722fea2eff9f8ddfdd";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/file/libmagic-mgc_5.45-3+b1_arm64.deb";
      sha256 = "3994076e338cb368881037fc5d4f0f98d7b5334393e5c2f510de9a400ff28ccf";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/file/libmagic1t64_5.45-3+b1_arm64.deb";
      sha256 = "5627348e412c0e448a2aebbd2dd328b8a37f83e3106684a08977db93d53fc97a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/file/file_5.45-3+b1_arm64.deb";
      sha256 = "7e786866e014a9b173d532863449024094ab925126c3dcb0369c1f5db6cdff77";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dpkg/libdpkg-perl_1.22.15_all.deb";
      sha256 = "b77d5fdc901d9057cd558d1b9c34ba4d47a444193ebf7f85957e3dc18cbea9fe";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/x/xz-utils/xz-utils_5.6.4-1_arm64.deb";
      sha256 = "97ff5f2535b930e99aa3022e4805ee172ee052894750a50d99100814bfabb47a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dpkg/dpkg-dev_1.22.15_all.deb";
      sha256 = "9ed603f1c79c284b9abc86a6f615f86d1a41ee6d1670ab7311d08df92dcd205e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pkgconf/libpkgconf3_1.8.1-4_arm64.deb";
      sha256 = "8a9477ed7af47d7ddefa1fe02bf9f87d6778e8cc59062064f1b076880a7a14a5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pkgconf/pkgconf-bin_1.8.1-4_arm64.deb";
      sha256 = "bce0638102650b61224901da320c2f867a91cfc133532a5fb526d2ce05465fe6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pkgconf/pkgconf_1.8.1-4_arm64.deb";
      sha256 = "aaf89947e9a5a6d980d14f43dfde8d0ad4e869b5cd33567321ca8baeb7ee7740";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pkgconf/pkg-config_1.8.1-4_arm64.deb";
      sha256 = "fef9662964fa4ff2ebbeefe076adffad79374f744274085c8ce931d5feb462a1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/shadow/login.defs_4.17.3-1_all.deb";
      sha256 = "1eba8412effd0c0f2d290b0d00b0dfb73263d6424ae19f904240eb8937b5a76f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/login_4.16.0-2+really2.40.4-5_arm64.deb";
      sha256 = "da033de1e36335668c37361fda5a5aeeda4cd32718b55c60306ddb1117de5aee";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libb/libbsd/libbsd0_0.12.2-2_arm64.deb";
      sha256 = "6827c1b3ad8dcbf3478803f9150359433e3376a3bde01c4503888a22eb3924e3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsemanage/libsemanage-common_3.8-1_all.deb";
      sha256 = "28fba03d5c00dd41a57964f265104cce2d820a1f28f2e83e5ac66e529655e602";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsepol/libsepol2_3.8-1_arm64.deb";
      sha256 = "a730c88ba7b9b6888cf046dee83db90a26a62f0798e84fb4e06bda5849aba81b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsemanage/libsemanage2_3.8-1+b1_arm64.deb";
      sha256 = "3798affa11a64a5d481257fd9518c133a5c4fe6bdbbc0d1dbf6d8242964fa95f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/shadow/passwd_4.17.3-1_arm64.deb";
      sha256 = "71fe6235d8639665678a553385846b6b071ca9e32c8698f9dfba539b39b17f4d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sysvinit/sysvinit-utils_3.14-3_arm64.deb";
      sha256 = "aa5f53e812fe12bf7b49672886c22bfdc76e4d00d6480ba5afbb226a3c525498";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/insserv/insserv_1.26.0-1_arm64.deb";
      sha256 = "8bbc013d4859104350f11c7ba1fa6fe43115545f4795c13035cb98f189bd86fe";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/startpar/startpar_0.66-1_arm64.deb";
      sha256 = "b43d365340ec3079c92a1ef2d222f2bd5d6e34769808360d82eb26bd33a2c25e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sysvinit/sysv-rc_3.14-3_all.deb";
      sha256 = "4db19a15402a913ae0cbf5827116c27685ea377119d037a83056b71ae8cfbbb4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sysvinit/initscripts_3.14-3_all.deb";
      sha256 = "349a2c9108258b3beab3cc37eb7ec60a7053b0784531ad4078be794ed993f19d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/mount_2.40.4-5_arm64.deb";
      sha256 = "3ace11d8e5307e6ba5274dd528960f64e9141be5344a991d011442d051116463";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sysvinit/sysvinit-core_3.14-3_arm64.deb";
      sha256 = "db9e0271a74ab539f20f2232204aa07faeb1e60431db0aa1cd0975a3c56dc2c0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/diffutils/diffutils_3.10-2_arm64.deb";
      sha256 = "566ee11b4ba0c8912f879067d73257358638439bd4bfc7518abb60d0f375dc00";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/icu/libicu72_72.1-6_arm64.deb";
      sha256 = "27a3f4be8f93a5daac4ea4f39b51fa6f3dc9b90deb5ccd0a026efd610a3030ff";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxml2/libxml2_2.12.7+dfsg+really2.9.14-0.2+b2_arm64.deb";
      sha256 = "975650b62ddaea79fe4e7b92e63287105b07da8701580e222e32637612a46cd0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/augeas/augeas-lenses_1.14.1-1_all.deb";
      sha256 = "489ab4b8d58fc93937294a54d4c0eb8776c253a9a53500997eca0d9a7f15fce7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/augeas/libaugeas0_1.14.1-1+b3_arm64.deb";
      sha256 = "4f6347c9a925530f48a5eff719c1eb9dccccffe37c0b8142e282247bca229acc";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/fuse/libfuse2t64_2.9.9-9_arm64.deb";
      sha256 = "c92aa3f45505aa5fbc4495e621e76edbfbfdd5ea33e90fd9c977b8b3b8df6543";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/h/hivex/libhivex0_1.3.24-1+b9_arm64.deb";
      sha256 = "1937f7501612b8c989ba419c062a5da913e8db0412eb9536f77c63fd1dc4c1c5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lua5.3/liblua5.3-0_5.3.6-2+b4_arm64.deb";
      sha256 = "42bb0ab1e6648650114ad28aa839600c6e242482826797e271dce685316365b4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/popt/libpopt0_1.19+dfsg-2_arm64.deb";
      sha256 = "b58ba178effc24280c4c6be3cf2c93a34607e18ad76b2f74b2de818136699076";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libgpg-error/libgpg-error0_1.51-3_arm64.deb";
      sha256 = "48fd5d6d74731bd4c278796d78eaadaeec4938614f90ac0c9444ed7622d78b0d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libgcrypt20/libgcrypt20_1.11.0-7_arm64.deb";
      sha256 = "6bbe0489bdad5d02b66dbaecb08d9975636bbf95e894195915240bca6cd7bdba";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rpm/librpmio10_4.20.1+dfsg-1_arm64.deb";
      sha256 = "26fc320660187b23056fc2456e002cacc4955df4e1927927a63c5b8b7f0508ee";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sqlite3/libsqlite3-0_3.46.1-1_arm64.deb";
      sha256 = "ae7effea7177d15156783d23421790dc585e2587add4d071b3b2812ce8d99232";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rpm/librpm10_4.20.1+dfsg-1_arm64.deb";
      sha256 = "49cb4f6a940974579932777975dd5fea1b712cd7d744405735b27d2780dd5a4d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libt/libtirpc/libtirpc-common_1.3.4+ds-1.3_all.deb";
      sha256 = "d31cc2c412789fdd234d6d84b148a5b355d64a2fa3fc21db397a7ccaa64fa7a7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libt/libtirpc/libtirpc3t64_1.3.4+ds-1.3+b1_arm64.deb";
      sha256 = "f3de5e60eb87243789ca27262e08499162cec6d8b32d0c2a0628d59b7220737b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/curl/libcurl4t64_8.12.1-3_arm64.deb";
      sha256 = "74e28eb71c21149821d8f43ac920fb8309d483c279234ef774149436d718ee80";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/expat/libexpat1_2.6.4-1_arm64.deb";
      sha256 = "dbb8a8c020295f4c19fdccc6b0da2c87a4657be0ffa07ec422aee4fa4538ac61";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/afflib/libafflib0t64_3.7.20-2+b1_arm64.deb";
      sha256 = "5504b6b111746b41b6b626fbef20a5db48af6c6048a2d72cdb55f60bd16a4369";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libewf/libewf2_20140816-1+b1_arm64.deb";
      sha256 = "e9b6ee4a7c45bb69ca9c4f8231a2d465771e3af6c71dfe1db6c76d3956b31ea4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libv/libvhdi/libvhdi1_20240509-2+b1_arm64.deb";
      sha256 = "dc73240d3f2d929a9e96c9c493db3444199ad276fdfdd0927712c012814dcbd8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libv/libvmdk/libvmdk1_20240510-1+b1_arm64.deb";
      sha256 = "09610ff49c672f52c0052af945421d6387c39148be048afa4e80655cbcb8d010";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sleuthkit/libtsk19t64_4.12.1+dfsg-3_arm64.deb";
      sha256 = "a1f115b6cd55dc5e968052ee9b37688788e412c51ef1fec19b24ddf15c93c474";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libv/libvirt/libvirt-common_11.0.0-2_arm64.deb";
      sha256 = "f9ce1308eb7df77c8e5c36ccef288e27e97dfc3ca34eb4fe90637e750682fe74";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/apparmor/libapparmor1_3.1.7-4_arm64.deb";
      sha256 = "0832e403a18d65a262d7a0716316e82be98b2dacc1fec1a1f89a69bfd6f15dce";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glib2.0/libglib2.0-0t64_2.83.4-1_arm64.deb";
      sha256 = "f52317d4901125a1f2bad9dbc04b0b9b3f8eaae5bb1db97a394497d811504c31";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/json-c/libjson-c5_0.18+ds-1_arm64.deb";
      sha256 = "f631829107005b15c2ca5c48ac74bc2df437c7eb608756eb865b147985f7bb45";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libn/libnl3/libnl-3-200_3.7.0-0.3+b1_arm64.deb";
      sha256 = "34e5b0b20a1c6056a79b7e19d9b8f8336c6166e67b19d6fc7ed99e4b4a6e9dad";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/numactl/libnuma1_2.0.18-1+b1_arm64.deb";
      sha256 = "0fdb47ac21333472212a668485e1b030ae69fd4e743754f7b974a2ee09eabfa8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libssh/libssh-4_0.11.1-1_arm64.deb";
      sha256 = "8371e0369ecc8a964796d2bc4b4a1b3e6c62c47977832d111c1ed54e765b884d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libv/libvirt/libvirt0_11.0.0-2_arm64.deb";
      sha256 = "4e0c15a85e7763ea2a75b532c45949b848c535a30d1a8072a86c7559448ca76d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/y/yara/libyara10_4.5.2-1_arm64.deb";
      sha256 = "7053ef0159f21c7f2ac024fbf19b2af1f8c510a8480c78d057828ec125830144";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/libext2fs2t64_1.47.2-1_arm64.deb";
      sha256 = "f6e370e9895b10791c29ad8950c256f7eb12d9d4decd59a1a22b81de65d7e3f3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rust-sequoia-sqv/sqv_1.2.1-6+b1_arm64.deb";
      sha256 = "3f1de7c95bd4f16f1c4c35d3edc6655d41036d389375c72f28967abce9a57166";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/x/xxhash/libxxhash0_0.8.3-2_arm64.deb";
      sha256 = "66665776740ced6c5ddcb48a89a92b056d0dcb13851e1ff573d2b99b766e5c6c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lz4/liblz4-1_1.10.0-3_arm64.deb";
      sha256 = "bd6e1771d1a3716b30f259a0892476e9d22e270870697d6b09851e79a3a13746";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/apt/libapt-pkg7.0_2.9.30_arm64.deb";
      sha256 = "13251d609530ac1b8998cc2cca1c9ee3795ddc9278da82332a8044680012a4c5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/debian-archive-keyring/debian-archive-keyring_2023.4_all.deb";
      sha256 = "6e93a87b9e50bd81518880ec07a62f95d7d8452f4aa703f5b0a3076439f1022c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libseccomp/libseccomp2_2.5.5-2+b1_arm64.deb";
      sha256 = "2121c9be647bda75a7c0f25cbeefec9de5e4aaad1025915f0f96c07c906d8c4d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/apt/apt_2.9.30_arm64.deb";
      sha256 = "35fe58dbb4869e02cc8a4b8b6a9cc5b818633bf3c811722c929b69141e2ab64d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cpio/cpio_2.15+dfsg-2_arm64.deb";
      sha256 = "cbb9ecfc347a854e78d56b7ebeb1b58cdc4316de816132588c457a76ee823d96";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/logsave_1.47.2-1_arm64.deb";
      sha256 = "dcc7ddb3ba63506b08e8d4c5f7608478ef4fb88c81721903ecf17b90d9cf0c3a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/libss2_1.47.2-1_arm64.deb";
      sha256 = "164ed70a3cdb77d941b1f0575f7553df00dc278963e866514d9f38b241b86216";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/e2fsprogs_1.47.2-1_arm64.deb";
      sha256 = "f697a0f239c64b9ea534d0538eb4e6a230124a0f7b6e6123afc0a9b923c86682";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/supermin/supermin_5.2.2-6_arm64.deb";
      sha256 = "a2b0ad9c51b7fb361ef6f23461fec9f4287610f5af7997a98d66c64161b345c6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/liba/libaio/libaio1t64_0.3.113-8+b1_arm64.deb";
      sha256 = "733b961bd2b6f1b644f14681ee57ce353e2854e21e49e445e3ae250e585c7301";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/elfutils/libelf1t64_0.192-4_arm64.deb";
      sha256 = "815b4265c7d6c89c5bbad456bdeed7af893da6912c9d16cf4c581001927c0e37";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libb/libbpf/libbpf1_1.5.0-2_arm64.deb";
      sha256 = "3f9521835db6f8f9dea7659320a3f1398092db2c8955f9f1550b94bf98dca79e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/capstone/libcapstone5_5.0.5-1+b1_arm64.deb";
      sha256 = "5f8f0731b815dd8589f8a3293640d58ab738bf103d783d8c56275af98ee2160a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/device-tree-compiler/libfdt1_1.7.2-2+b1_arm64.deb";
      sha256 = "43b3435ff8d67a3cbd91f88bdeffcb147f7f5da61fba50cf004505f03025ae1e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/fuse3/libfuse3-3_3.14.0-10_arm64.deb";
      sha256 = "f24d97ec99594f56dacb500c84ab44071b9c0c7e53ba785f0750f27acd6caf1b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/adduser/adduser_3.137_all.deb";
      sha256 = "40b77d8b5b482baee2d0c95bbb4a4b9bcf7271b79dec039ef45e541142edfc12";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libn/libnl3/libnl-route-3-200_3.7.0-0.3+b1_arm64.deb";
      sha256 = "51597e3bf3559cb03c33dc675fd668be2961c61f987e8f2a353a20a8876b1316";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rdma-core/libibverbs1_55.0-1_arm64.deb";
      sha256 = "bc0819ae1f0e7084155594fdab6b5b31a1b225ed869e7cb7c7160358d7a625d9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libj/libjpeg-turbo/libjpeg62-turbo_2.1.5-3.1_arm64.deb";
      sha256 = "10826a6910a0af0d8ae96e903e12f669bf87bd945bf1f2a342a85b5911d27c95";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pixman/libpixman-1-0_0.44.0-3_arm64.deb";
      sha256 = "b502cd8b1ece222f42b44c42c33a300d84152c20089660167b9422ad2ebb6132";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/kmod/libkmod2_33+20240816-2_arm64.deb";
      sha256 = "4e33a4ccd7a45ea9ab937b82a780cf857b4bcce61eeb1341f8a9857a13a24f04";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ndctl/libdaxctl1_77-2.2+b2_arm64.deb";
      sha256 = "72989645d5ced8af6b7afa3f3441ed8d7813abadaa8d0b1e53195d9dd564b09b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ndctl/libndctl6_77-2.2+b2_arm64.deb";
      sha256 = "92ef010734bd16725e7f0377aebd6a22a59c695bfd6d1f033367803769e0113e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pmdk/libpmem1_1.13.1-1.1+b1_arm64.deb";
      sha256 = "6fb4d7569f301d279211f0bc53cda7c21324aec7f2b7e4c8ed30928bbeb88384";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libp/libpng1.6/libpng16-16t64_1.6.47-1_arm64.deb";
      sha256 = "523ff56c2ee2e8945e400cb636f3f2b055a9d943949bd931765e8cc834c1d355";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rdma-core/librdmacm1t64_55.0-1_arm64.deb";
      sha256 = "58c73feef4c1d0af65abe1465090f070e7f37a8049a23a20a3c0cf15bbab8a13";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libslirp/libslirp0_4.8.0-1+b1_arm64.deb";
      sha256 = "adc6ccaa69b8305269da98b293d3da28f69dfd664e9a1037b7326a47006d8bd7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libu/liburing/liburing2_2.9-1_arm64.deb";
      sha256 = "523dfbe829acf3aeae6df81528426a75995944923fd6bd35f6ccd0332034c713";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libexecs/libexecs1_1.4-2+b2_arm64.deb";
      sha256 = "749229c6aa58a6595db3352c4d3ac3bfbba6991e94a6196bec7d21624d33d88d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/v/vdeplug4/libvdeplug2t64_4.0.1-5.1+b1_arm64.deb";
      sha256 = "6651077e2156305d3151d57756b6072086a8ee3dbce405b11063ea9f78cf8768";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/alsa-lib/libasound2-data_1.2.13-1_all.deb";
      sha256 = "bac4c89919fcf9f2fad94049312d9368ad0852bffdda1c1be5f353a34916b35f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/alsa-lib/libasound2t64_1.2.13-1+b1_arm64.deb";
      sha256 = "72d85facc6f8b0adccb2b2c1a01c3e160a89e32cb4ff9ea2b4edda19babf741e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/brltty/libbrlapi0.8_6.7-1+b2_arm64.deb";
      sha256 = "50ebf6b786a2d0febab26cae86313c6473383aea7f77fe3fddd8b3a28da7a47d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nspr/libnspr4_4.36-1_arm64.deb";
      sha256 = "b8cd0221e4c35a77ec6e3b89959ca96deb75919a3c55b6735ca0288a1b61bdbb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nss/libnss3_3.108-1_arm64.deb";
      sha256 = "c0a7bf34d82d46860757797aaaa5d2b9526fa775935cae0be97f2709d6ac90ab";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pcsc-lite/libpcsclite1_2.3.1-1_arm64.deb";
      sha256 = "f9811f4a8b1cc3f11bbdd46c2b4b8e01fb1c3e37763488ee52842f91c3a41b73";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcacard/libcacard0_2.8.0-3+b2_arm64.deb";
      sha256 = "54f87ddff1f4ea2dd0b9d14faf7283ce9af1ae02e3a7567af17842251c5266b8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ncurses/libncursesw6_6.5+20250216-1_arm64.deb";
      sha256 = "d9b604e7641f3381cf3fe9ad19f8af5a90143372d5a5df6a783528d05af79f7c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libu/libusb-1.0/libusb-1.0-0_1.0.27-2_arm64.deb";
      sha256 = "5864658ab21e3b9e8322bf35209be964434260e4c9a34c1fd4ad4b61f991d5b0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/usbredir/libusbredirparser1t64_0.15.0-1_arm64.deb";
      sha256 = "72a2674abb3dcf56519e93a8fa1e7f6907114ce772a7876ed67e5878dad12d7a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/q/qemu/qemu-system-common_9.2.1+ds-1_arm64.deb";
      sha256 = "e57e9c84c14f8511c74540fd1636257851f445f8e1c09e47b4ade93d3e708076";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/q/qemu/qemu-system-data_9.2.1+ds-1_all.deb";
      sha256 = "7e5a9506737386a4f3bb7d865253837d8945f6c35a4ed38014c3054aac80a847";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/q/qemu/qemu-system-arm_9.2.1+ds-1_arm64.deb";
      sha256 = "e0e1ca21c2d0ed764bad40e2f9e31c53ffa7e43741dd1237d281125cb7cdc21d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/q/qemu/qemu-utils_9.2.1+ds-1_arm64.deb";
      sha256 = "3ba1fda96256e65f3f98cd0763c66c9a54371342c47dc81ea3634dd3b2f51607";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/db5.3/db5.3-util_5.3.28+dfsg2-9_arm64.deb";
      sha256 = "dc9d8b9282e44ebc176fd322df641f3ab4eb9062af5ece161b5e110473a61a31";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/db-defaults/db-util_5.3.4_all.deb";
      sha256 = "1c1bf1d3905c975b55339d3b268ec879658848aee568d5d1ec62635bc1bf23b0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openssl/openssl_3.4.1-1_arm64.deb";
      sha256 = "6acc9a1f51b976a7c439d70f7780a314608e246f32447c5d9b2caf3859afa356";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/ca-certificates/ca-certificates_20241223_all.deb";
      sha256 = "bb96f2467c71323e738349080520689e4697df88c7ee90a83e9bcff1d29f3f5d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libencode-locale-perl/libencode-locale-perl_1.05-3_all.deb";
      sha256 = "071bff2a1d193ec1b0d71e1a1ba7e718909866874e600f19d99a6f8c5ae30bcd";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libt/libtimedate-perl/libtimedate-perl_2.3300-2_all.deb";
      sha256 = "8e36723da883c2975d83199e7f4b5331e291881372fde944b0d56660965f38bb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhttp-date-perl/libhttp-date-perl_6.06-1_all.deb";
      sha256 = "b46bf28a321e344be21b3161969c613abeddc63b1ff627ee94487a0ee4b53eda";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libf/libfile-listing-perl/libfile-listing-perl_6.16-1_all.deb";
      sha256 = "171410be7be03a39e6ad531b19d3b95049d43dae9f19076fe250b3b7bcc30574";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhtml-tagset-perl/libhtml-tagset-perl_3.24-1_all.deb";
      sha256 = "5efdaf433e10ce127257176d8093e41eabc642839e71f1961bc17f2e4f6169b0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libencode-perl/libencode-perl_3.21-1+b2_arm64.deb";
      sha256 = "e49158dfe936aa72b4ac199132e44d4f1277028bcf08cf6294e6c9f38f2b294c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libscalar-list-utils-perl/libscalar-list-utils-perl_1.63-1+b4_arm64.deb";
      sha256 = "76177ee7a2a67b9d1c0c1c3f0df4b4996b6beb60d627c767b55a781819f48635";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libu/liburi-perl/liburi-perl_5.30-1_all.deb";
      sha256 = "33957bd8218ddd3a86cc19fdf3bf7832b0640337a4be6cf23b2714b73d220220";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhtml-parser-perl/libhtml-parser-perl_3.83-1+b2_arm64.deb";
      sha256 = "0ce717bb16456ff28219ffc27faedacc38a0c521c2659bb0c39dd90dda1725a3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhtml-tree-perl/libhtml-tree-perl_5.07-3_all.deb";
      sha256 = "00f857bb27388432df3e4d6510334a560c2de19feb4b31897cb5d83251bb54ac";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libclone-perl/libclone-perl_0.47-1+b1_arm64.deb";
      sha256 = "48e3a080da34e615d64d495a8c9d0c745115a479d1f1120f2fb44b706d596e4d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcompress-raw-bzip2-perl/libcompress-raw-bzip2-perl_2.213-1+b1_arm64.deb";
      sha256 = "3ef7c86048a15eb7af640b4580be6da1500a17ee3e827566eb947c3d48c61d24";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcompress-raw-zlib-perl/libcompress-raw-zlib-perl_2.213-1+b1_arm64.deb";
      sha256 = "d723a20baa3ba32f052e73a50b5440f4e885d4d25bae52abc8e9e20336bb8b22";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libi/libio-html-perl/libio-html-perl_1.004-3_all.deb";
      sha256 = "66c87e3e92460b9dcf56257fd6a48cc7fd1283790acb365a111ecb9d74e9ea43";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libl/liblwp-mediatypes-perl/liblwp-mediatypes-perl_6.04-2_all.deb";
      sha256 = "c3ae8bca625ab6e16d6257698de402090135b5eca511df2c8086b0c23eefbaff";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhttp-message-perl/libhttp-message-perl_7.00-2_all.deb";
      sha256 = "e55e830b16af9c2b5269000c4dd9b93fd24b304a0675aeb0ab83438c566d2ca7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhttp-cookies-perl/libhttp-cookies-perl_6.11-1_all.deb";
      sha256 = "f3a57264a6704bd22397c644b1b91ed6055bdb190bd4d5d995cdf92840d049ed";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhttp-negotiate-perl/libhttp-negotiate-perl_6.01-2_all.deb";
      sha256 = "b2770aaf4d638283d9b4f713005702fbab42304be169cb4d6761e8537f724261";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl-openssl-defaults/perl-openssl-defaults_7+b2_arm64.deb";
      sha256 = "1fa2d99f1f7d32147cd5935eb2700ac49b366c086fea21c963c73e6dc62d62b1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libn/libnet-ssleay-perl/libnet-ssleay-perl_1.94-3_arm64.deb";
      sha256 = "50622582eec91dac26bf34e19a255b4e1bfaaf9cf44431fb437f3ade9bcbb7bc";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/netbase/netbase_6.4_all.deb";
      sha256 = "29b23c48c0fe6f878e56c5ddc9f65d1c05d729360f3690a593a8c795031cd867";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libi/libio-socket-ssl-perl/libio-socket-ssl-perl_2.089-1_all.deb";
      sha256 = "9fe58e2dd2847896e380f9fb26b5344d62cab21d8390598912e485ceedb30f00";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libi/libio-socket-ip-perl/libio-socket-ip-perl_0.43-1_all.deb";
      sha256 = "f9c5929f513c20b0500db78cc4a4a75d5d74d95a67bbfc10e1776363ab81b5f3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libn/libnet-http-perl/libnet-http-perl_6.23-1_all.deb";
      sha256 = "ef8220824939149b88ff230081e4bd686d1d92f0a233c4f80d1e14115ab1b510";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libl/liblwp-protocol-https-perl/liblwp-protocol-https-perl_6.14-1_all.deb";
      sha256 = "9201070118916bfbf3111008cac59769fb240376bb04e981132805a915f57223";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libt/libtry-tiny-perl/libtry-tiny-perl_0.32-1_all.deb";
      sha256 = "f160af736fa67df5a5f6ec222d28e6c188b5b87965bd649956a6bea8795c1d3a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libw/libwww-robotrules-perl/libwww-robotrules-perl_6.02-1_all.deb";
      sha256 = "be69cda8c2a860e64c43396bf2ff1c7145259cb85753ded14e0434f15ed647a0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libw/libwww-perl/libwww-perl_6.78-1_all.deb";
      sha256 = "ddcecf6d01b33f14faf6ebd511deb114fcb0c043bb4291e4b45c82cbe7b4ec88";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/icoutils/icoutils_0.32.3-6_arm64.deb";
      sha256 = "51d975bc7c9407def9f5199d505cec40a10096a2490281cc12dd54d08115e221";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/netpbm-free/libnetpbm11t64_11.09.02-2_arm64.deb";
      sha256 = "0998cb82683f21db7581e1af22e2251d7697ae9546f5b9de3c5d2c25293e861c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libd/libdeflate/libdeflate0_1.23-1+b1_arm64.deb";
      sha256 = "644c852d3ca33a221c833d32b9000dd8108ac6afd4e83c836542c59c2a629941";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/jbigkit/libjbig0_2.1-6.1+b2_arm64.deb";
      sha256 = "dbecef09dbafd82ff6444aa1cb45053b6331985b20ab2590eff052d7d6b1bb18";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lerc/liblerc4_4.0.0+ds-5_arm64.deb";
      sha256 = "db015dc1888371e490594f8aaaaa55356313478d744fa69e242e034e4c2a0019";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libw/libwebp/libsharpyuv0_1.5.0-0.1_arm64.deb";
      sha256 = "5a37f40f806df4b67a2bdaa750add7a9ff29abd3119a8ceac773b886cbf3d9f9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libw/libwebp/libwebp7_1.5.0-0.1_arm64.deb";
      sha256 = "d5ebdb920770ee135c4e319babb2bcef61e9f37283a37a8cb4e673769dd0d676";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/t/tiff/libtiff6_4.5.1+git230720-5_arm64.deb";
      sha256 = "454975d025d0159adea62dd752a8ae4ae6dffecf1273ff14f009f7fb3cafec4e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxau/libxau6_1.0.11-1_arm64.deb";
      sha256 = "ac1061728670f4626adaa1288953a0e6fb801c9cae72ee1c3231e63e2609d23a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxdmcp/libxdmcp6_1.1.5-1_arm64.deb";
      sha256 = "e10bbb0802181992ecf091e9425171850eee16068729c109214ba4924f81fb52";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxcb/libxcb1_1.17.0-2+b1_arm64.deb";
      sha256 = "d0178198e80ed4cacdececabe2c112ec88c7a9258cc11a55b8e267ab14a90d82";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libx11/libx11-data_1.8.10-2_all.deb";
      sha256 = "fe7976c52351e7c403e6beb75a943111bbcd673a13540b85541ca71d1285dde0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libx11/libx11-6_1.8.10-2_arm64.deb";
      sha256 = "5c5fca8a2423d431151153712456ce3a41311da5456432beb35ea20a7ec67e1f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/netpbm-free/netpbm_11.09.02-2_arm64.deb";
      sha256 = "76c25b02fe6942ceeddcbd2664d21870045be115285cb1ce19af68bbf1c20af8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/osinfo-db/osinfo-db_0.20250124-1_all.deb";
      sha256 = "0c3d3688f5308311adf7d9ab45663eb7cf30d96e49585fcc8cac3bb9d8057658";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/acl/acl_2.3.2-2+b1_arm64.deb";
      sha256 = "099b5f8bfa3ffea30a10308a89a5467d3fa7d8d16b94df931f0299344c2a4291";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/attr/attr_2.5.2-3_arm64.deb";
      sha256 = "0aa332f846145248135aa782cfeea722ff6a4b9386a08455b84dceecdb301ec1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/bsdextrautils_2.40.4-5_arm64.deb";
      sha256 = "8ab302d8d1676b45d7c777a4ebe9830544a9c09b84003919e1baa9f69851495c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lzo2/liblzo2-2_2.10-3+b1_arm64.deb";
      sha256 = "ee0f990bef6693c8249d7a3de4b17f65d549beae84b6d1413421618ac6427914";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/reiserfsprogs/libreiserfscore0t64_3.6.27-9_arm64.deb";
      sha256 = "d6b935a8b795ae0e4a3e0445b287ec0140e78f4180f360cff37e6cbed0878f8e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/btrfs-progs/btrfs-progs_6.12-1+b1_arm64.deb";
      sha256 = "d74f8cbf66917f9330d306bf83185d718d9814bf92a9e953bdb89fc40114c41f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/dmsetup_1.02.201-1_arm64.deb";
      sha256 = "275a9e9d37d86d32513b2c5643066a137826b65b922c0a4b91e3abc4baffb84d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/libdevmapper1.02.1_1.02.201-1_arm64.deb";
      sha256 = "33b5e4b37419c9bc90e7871e116b22a37e6e95d62c253550a844dd2bbc196825";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cryptsetup/libcryptsetup12_2.7.5-1_arm64.deb";
      sha256 = "5c89a3d284ff54eee4adc60dab622498e932d066ad6efcf87c3513d631f50f3f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cryptsetup/cryptsetup-bin_2.7.5-1_arm64.deb";
      sha256 = "71bf8b15653e9351b3c4191ab053d07c19b80e89267415e68b8be9f3a682d2db";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dosfstools/dosfstools_4.2-1.1+b1_arm64.deb";
      sha256 = "7c9dbc889c2f143caa91c69b4750dc1d2afc4da168da9b6e7ab896e441bac8eb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/exfatprogs/exfatprogs_1.2.7-3_arm64.deb";
      sha256 = "d1777899b24ebc1b33bf02187ebf0f08cd4646b82aadd23bc199587229e14abe";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/f2fs-tools/f2fs-tools_1.16.0-1.1+b1_arm64.deb";
      sha256 = "6c0b6c6b79d2c8d8ced7f2ba9a5eb813ba6108b7a3fd3213d0afb509944b07ec";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libfdisk1_2.40.4-5_arm64.deb";
      sha256 = "bd5e8f1607bd19ac079a8b8e2ef7df1f450ca005f3bf5de3fc7920e04def56f1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/readline/readline-common_8.2-6_all.deb";
      sha256 = "f77e8aa0bf0de618f11cb0b21658a4ed60f177d63b3cf26d7fc3706b6d0eaaa9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/readline/libreadline8t64_8.2-6_arm64.deb";
      sha256 = "f78ff432b2a627bc04f7eef0e6e2696501c9e06feca748a5b741d5e594429033";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/fdisk_2.40.4-5_arm64.deb";
      sha256 = "856aaa0997424069f522027cc006851d163d31571c88458ae046963b7adcaeb7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsigsegv/libsigsegv2_2.14-1+b2_arm64.deb";
      sha256 = "4fd72af654e2a72c84093cc2a38c856fba9492ecd828721117867e99c2c9cd92";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gawk/gawk_5.2.1-2+b2_arm64.deb";
      sha256 = "0c040f686b0dd34387c0aa69848dd9f29741043821a843b480c38a1cf5956142";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gdisk/gdisk_1.0.10-2+b1_arm64.deb";
      sha256 = "b6b48390e63bff9d18b32be3270910fab83f8c14117d49ada13cba8a2a75c7e9";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/efivar/libefivar1t64_38-3.1+b1_arm64.deb";
      sha256 = "16f70b215c390790294ddf454e0c244bc8f64104b361d8ef5790a17f06c7bc16";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/efivar/libefiboot1t64_38-3.1+b1_arm64.deb";
      sha256 = "a19f6a081314f9ddc246d1e8a0141ac866fd0b34bcbfbabb47349f10f3a1fa24";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/freetype/libfreetype6_2.13.3+dfsg-1_arm64.deb";
      sha256 = "dcb545c78601b14049e85901f8f83ddb5d05b7792ae6188b21d0edf7dc449ac0";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gettext/gettext-base_0.23.1-1_arm64.deb";
      sha256 = "5dca3bd324a7eab3d6a33125ed4ca2f186e88f9b8eb233fa471a86731a24892f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/grub2/grub-common_2.12-5_arm64.deb";
      sha256 = "634c56700704064cdbf3465d720611e22b737c1c86e332c6acfd3f86d555c867";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/grub2/grub2-common_2.12-5_arm64.deb";
      sha256 = "7e2da95b620d06d1b25fb25a42f0d8f6cdde4352f9b84264762e017f78d6ea20";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libm/libmnl/libmnl0_1.0.5-3_arm64.deb";
      sha256 = "f21bb29056e9ede0031cc411ffa3b1272858fa4b950e1cd9e50756c5c2ece97f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/iptables/libxtables12_1.8.11-2_arm64.deb";
      sha256 = "b200a559a4ae1b4ebcee4fb0fcaef6a16ef01abbe3da8887de15e800b1a6440d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcap2/libcap2-bin_2.66-5+b1_arm64.deb";
      sha256 = "f0b41aaf2a4afe1a5845cac679224cf9ae6a3632ad9666e9ced4248b227304ee";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/iproute2/iproute2_6.13.0-1_arm64.deb";
      sha256 = "459265e763fa0900c373b514fce07790ad03b4c7bd04c2b1c8d1d12051765776";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dhcpcd/dhcpcd-base_10.1.0-7_arm64.deb";
      sha256 = "827487f65a40b167f9bf0adbb467f034e17b2e7b65636d3ac133115aacb3611d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/kmod/kmod_33+20240816-2_arm64.deb";
      sha256 = "972b43517f34d660ef91bfe68e2d7bf09e713a29e53745a7c301ae1d2034668d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/json-glib/libjson-glib-1.0-common_1.10.6+ds-1_all.deb";
      sha256 = "70cf0f4d8e71f0404c989df7502fb5d8832439354c1a3e809c86f1b0df6b5e9a";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/json-glib/libjson-glib-1.0-0_1.10.6+ds-1_arm64.deb";
      sha256 = "e87aeea6d81c35ad0089a03743bd33f548b949bb4115d6c5626be4be7cc6784c";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libl/libldm/libldm-1.0-0t64_0.2.5-1.1+b2_arm64.deb";
      sha256 = "337a0beb5aadaa46fa4e53a903871cf49f978dd1519cb258f098d0fe77af2b68";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libl/libldm/ldmtool_0.2.5-1.1+b2_arm64.deb";
      sha256 = "f9730dd69845213cbc3eb171c84f75b98738553023398ea8633f11b09772eae6";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/less/less_643-1+b1_arm64.deb";
      sha256 = "08be695e5e339005a3bd2cf02110f3d6829469c6c2bd3303583dfb67628f8f46";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lsscsi/lsscsi_0.32-2_arm64.deb";
      sha256 = "ea4da5290d51465f3748f098cdb39772789a9aa3c6581df4fbf4dd42aa8c0436";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/libdevmapper-event1.02.1_1.02.201-1_arm64.deb";
      sha256 = "858622d066d0a46d658c827ec60f4b481995c14fd6ce778b3332bc20e6d32e2d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libedit/libedit2_3.1-20250104-1_arm64.deb";
      sha256 = "496c31df89fac9cb7e98102fcc21daf887376dcd9914f6322c86dd5bd4360ff1";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/liblvm2cmd2.03_2.03.27-1_arm64.deb";
      sha256 = "b60607a4a6fb2034e2f0cacfd2c974d5ca92737f5d2db8dfebf43448bbbf14bb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/dmeventd_1.02.201-1_arm64.deb";
      sha256 = "eb0c6898892ed86fdeac38ae680dd9a1a898c4ba39c8412dfdacfe26d29e0f4f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/lvm2_2.03.27-1_arm64.deb";
      sha256 = "ee9f76f638f0ebd64f7797a40ae0517f959bc34db2692cd3ca663dc4132d501b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lzop/lzop_1.04-2+b1_arm64.deb";
      sha256 = "20a7171efc5600198bf33e510b3c48012a2b5af6cfda22e14bf634979c21a548";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/libsystemd-shared_257.3-1_arm64.deb";
      sha256 = "fcad5d3e9d6e13d6438368578d2c2d403476d9dd0714270ecd224e2fde8b4b19";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/systemd_257.3-1_arm64.deb";
      sha256 = "59af85188381345e710de7b0cd815994d59c5f0f95de86e0d47df2e9659d992d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/udev_257.3-1_arm64.deb";
      sha256 = "fb74c523e1c772e58878f853937fbeac015ccc251376cd54bf76c1ee813ef3f0";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mdadm/mdadm_4.4-5_arm64.deb";
      sha256 = "d856ddd1a4d3082ee7a3bdff9936c1a5359f2853a8590f17dcf571308c3c2b23";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mtools/mtools_4.0.48-1_arm64.deb";
      sha256 = "296cf0a6b06433520effc30542a695307f4abf0d377f94d8a22dc8bd1dd4785f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ntfs-3g/libntfs-3g89t64_2022.10.3-5_arm64.deb";
      sha256 = "045db448e206c139a4738a4ae995a7f50d55e10ff34ec19a62701b6ac57e10fe";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/fuse3/fuse3_3.14.0-10_arm64.deb";
      sha256 = "44c8d62edab776f227975a5db53a41cfb5c2abc6b0d270608e0359cf1c05febb";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ntfs-3g/ntfs-3g_2022.10.3-5_arm64.deb";
      sha256 = "3e45bce3d720317d740a57a8192e51250b049a543645f4e317d2e946d93df67a";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcbor/libcbor0.10_0.10.2-2_arm64.deb";
      sha256 = "5e129095192ff766884e5ed13260644e510d20ed6b4facc47809bf2cb630117d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libf/libfido2/libfido2-1_1.15.0-1+b1_arm64.deb";
      sha256 = "510f81957f2905c57d3d8681c3ed9bf68a17bfb254d721a578c88edd8158477c";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openssh/openssh-client_9.9p2-1_arm64.deb";
      sha256 = "cfb7f244d1984b1d29c125274412177000690716388af898ff45c4f01193d41d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/parted/libparted2t64_3.6-5_arm64.deb";
      sha256 = "cc441a27a61a0d7320cc991f147049b12444c6e290277f1a0a5a3fc5942ded63";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/parted/parted_3.6-5_arm64.deb";
      sha256 = "62006921ec2a8b10ad3e52d0bbaf41b31f6806ea5d3ee15c8544b379c6e712ab";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pci.ids/pci.ids_0.0~2025.02.12-1_all.deb";
      sha256 = "483aad3ad6cb3d0003499139107b24254d0deebfbb7e690dabf44e8a1d80627e";
      name = "pci.ids_0.02025.02.12-1_all.deb";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pciutils/libpci3_3.13.0-2_arm64.deb";
      sha256 = "fde73536f93fcd930362531506f8431b2e959bfbdeb41e772100c1cfc1f83953";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pciutils/pciutils_3.13.0-2_arm64.deb";
      sha256 = "e60b3a48ce93ed5634713226b6ca623a7e7a77007ac0de0a38698c84f36e1867";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/procps/libproc2-0_4.0.4-7_arm64.deb";
      sha256 = "dcf2f6288634548ad2d76220195410bbcca66f97922a548dfa69afdc9ee15aa4";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/init-system-helpers/init-system-helpers_1.68_all.deb";
      sha256 = "119713cf7ab3535ac141eea4a11d76ceb117b3326f237c87dc2d4ab9ecbd5620";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/procps/procps_4.0.4-7_arm64.deb";
      sha256 = "6f76018ece35808db1841cc3d004ec008386a89f5a1b40980e28d5a1991e8547";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/psmisc/psmisc_23.7-2_arm64.deb";
      sha256 = "9ebae564434a8fb5f23b770b5810e9e9c887cde32c23498f340db353a629c993";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/scrub/scrub_2.6.1+git20240819.9b4267e-1_arm64.deb";
      sha256 = "e0df9cdf3b98ad76a43bbbda51efeb6331d6d032ef47bde9f48dede089529ffa";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libd/libdate-manip-perl/libdate-manip-perl_6.96-1_all.deb";
      sha256 = "be8f09cbd685a30db35f0c63407df6d45e4b600108e283a5b4bfa25cc4af49f9";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libb/libbfio/libbfio1_20170123-6+b2_arm64.deb";
      sha256 = "476005fd9b111e0fa36cdfa18bf6e7a7b383c43a3779f8c798e137911df6ba3b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sleuthkit/sleuthkit_4.12.1+dfsg-3_arm64.deb";
      sha256 = "2396c1365534d29c77b351cdab56da5544e21b43b70c678f392eb897d40d7cf2";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/squashfs-tools/squashfs-tools_4.6.1-1+b1_arm64.deb";
      sha256 = "c074f409b735b80ca5dbbf415436aef49a162e2daf148de007ffceabf0332304";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/systemd-sysv_257.3-1_arm64.deb";
      sha256 = "b4ee2cdca3fad9734470740efe15fc9a53b710c15f369c4e20d3b7910bc23c3f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/util-linux-extra_2.40.4-5_arm64.deb";
      sha256 = "a4bce4aa7b4f28a81c9e692953f258115dd663c9f070c3dd6e7554639449a846";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/uuid-runtime_2.40.4-5_arm64.deb";
      sha256 = "48b74f778d54cd16ba2642bdbab1027234ad6278a9a56362bda5ba46c8e1b108";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/z/zerofree/zerofree_1.1.1-1+b2_arm64.deb";
      sha256 = "1b96d1b2b3ff430dc0804634397d166fed6fdcd3e7af9bb8bb5cedc330492e12";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libz/libzstd/zstd_1.5.6+dfsg-2_arm64.deb";
      sha256 = "e521ebd98c5308f36b55e14c0e7ac2fcc1a9794685f36d11c1d33bcdf5091a63";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/libguestfs0t64_1.54.1-1+b1_arm64.deb";
      sha256 = "7f9d6732fb55a9f4aaaf982799e79cdb6817d9e598ebf16a341e8bac93a6ccb0";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/duktape/libduktape207_2.7.0-2+b2_arm64.deb";
      sha256 = "9dcf4d316a8ece7277d21bbdd26b75a5d7d829faf3c7cfd861e30ba89d385516";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libp/libproxy/libproxy1v5_0.5.9-1_arm64.deb";
      sha256 = "7758242ac0263b1fcefc01622160c6a965a25d7f284ee6a62a46a8784cfedd6e";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glib-networking/glib-networking-common_2.80.1-1_all.deb";
      sha256 = "aa697ddbd07ba9e16391bd81f73661b2583859c8671d1ce92f28e6a870d37059";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glib-networking/glib-networking-services_2.80.1-1_arm64.deb";
      sha256 = "231f911c07eb9cb4a68b6709e0963aaeddeda523f21d24f10a593d4c2963f982";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/libdbus-1-3_1.16.2-1_arm64.deb";
      sha256 = "8470c9358b31151d9cbbc94e8f76d6e1b4553c2bde34fd72a148edb8df5ce7b8";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus-bin_1.16.2-1_arm64.deb";
      sha256 = "8813f401a4d43819f9ca4a97334200e716b52e4121b19b377812ef4ee9cd1d24";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus-session-bus-common_1.16.2-1_all.deb";
      sha256 = "3e02d0c4c3bdfc77972aa404a51f04f76b7a2353641c395091793bea4d7d46d9";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus-daemon_1.16.2-1_arm64.deb";
      sha256 = "f8a56cc2a4928497eb0cb3ba1ff0aa2f704ae82c2809cc1e32e84334ec39d108";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus-system-bus-common_1.16.2-1_all.deb";
      sha256 = "e28a4a0e057fe4da53b60898f52670214a56f9b820d1431c55721a5f56656b97";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus_1.16.2-1_arm64.deb";
      sha256 = "d802b34a3888ae9135e9acfae1baf4b0a11532168186190a2afe409e0b4db911";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/libpam-systemd_257.3-1_arm64.deb";
      sha256 = "1f35562195fc038eb8a68f5f12bb49a6ea096516060c5f9779cedf086a696df3";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus-user-session_1.16.2-1_arm64.deb";
      sha256 = "b3e01b4ce6363cd13cc21f3da9fcba10ddddcb10fd40b03574586d632704caf8";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dconf/libdconf1_0.40.0-5_arm64.deb";
      sha256 = "ff0a3e38b2fb4b96f209a3ae75714cb14e0df14a26a1aded11f5afb87d0eaef9";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dconf/dconf-service_0.40.0-5_arm64.deb";
      sha256 = "da9d81b0cd090e3933367a9be7562f13edebc9fd06f6f631c9e41fbc0a082fc3";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dconf/dconf-gsettings-backend_0.40.0-5_arm64.deb";
      sha256 = "6ba9fcaa892934c9cfc601aeca15cfbac9751cb1377c541b1b0e098ab587a31d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gsettings-desktop-schemas/gsettings-desktop-schemas_48~beta-1_all.deb";
      sha256 = "e58a08f7841150134ae76f14c3dfab03520069dc56d3fe8a27c1a8de11189b64";
      name = "gsettings-desktop-schemas_48beta-1_all.deb";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glib-networking/glib-networking_2.80.1-1_arm64.deb";
      sha256 = "06815a6cfd3ad5386eba73db253ea1a25ede4a01b3b92d1dbc5315d001915e21";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsoup3/libsoup-3.0-common_3.6.4-2_all.deb";
      sha256 = "eac04de1dcaee4899dd93dde51beac8f14b26fcac2e382a247130e92d2e9fff1";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsoup3/libsoup-3.0-0_3.6.4-2_arm64.deb";
      sha256 = "f924d7d54172bc82ed5b11f8a6656193f050339f4e993c92f8d293b9a6fb60bc";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxslt/libxslt1.1_1.1.35-1.1+b1_arm64.deb";
      sha256 = "764fe34d60341143c9aa43ee8006591f1685b0769413e7df473e367b80f81e51";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/usb.ids/usb.ids_2025.01.14-1_all.deb";
      sha256 = "07d11308eb6021b984ae6e15afd0c1b4e6ded6463d05e3930db6d252c2e3287f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libo/libosinfo/libosinfo-l10n_1.12.0-2_all.deb";
      sha256 = "3d8c424973c15f69c7c52916e6e27ebd522decdf004abd7ff88ff2380ca21808";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libo/libosinfo/libosinfo-1.0-0_1.12.0-2_arm64.deb";
      sha256 = "c572276f24b6485f7c0065c7aa60a37d6b5c33207bc48305def249fff0ef2410";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxml-parser-perl/libxml-parser-perl_2.47-1+b3_arm64.deb";
      sha256 = "130645a2cd46e8133cdaae96f0bfe4b99ba43bd08d60457fc3189a5da8669429";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxml-xpath-perl/libxml-xpath-perl_1.48-1_all.deb";
      sha256 = "af896c45e1dae5c0a4b9dec19404f41b688fac0e444f8744522fa3d04ccd9b9a";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/h/hivex/libwin-hivex-perl_1.3.24-1+b9_arm64.deb";
      sha256 = "526e362fc704a0597a00e00242c238e80d38c67e8d965f4e5ab2ba05924d6d48";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsys-virt-perl/libsys-virt-perl_11.0.0-1_arm64.deb";
      sha256 = "df77ce5525c3a7472cb8f4ccbe5c902fb46c6d22f795215faecc9cbff40666a1";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/libguestfs-perl_1.54.1-1+b1_arm64.deb";
      sha256 = "0dfc8918597fd76d8cd290d1285b5d160b63cfa68aa5167a8226c2eb8d9bbfc8";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libi/libintl-perl/libintl-perl_1.35-1_all.deb";
      sha256 = "056ebe90f7ca7046f7f64e5eea8ed57d2da19a9531646bcf1f7856a5da07fb27";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libstring-shellquote-perl/libstring-shellquote-perl_1.04-3_all.deb";
      sha256 = "5860ee3928d3031a5a43ecfd8b3c093c58885cafb865473a612b9571d48e6d6a";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/guestfs-tools/guestfs-tools_1.52.2-4_arm64.deb";
      sha256 = "da8560b4b684ce0379de89f59e9d8c10c8463191600b20b87282186d953ada8f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libconfig/libconfig11_1.7.3-2_arm64.deb";
      sha256 = "d1c7cf833b21df577682865a8867b8124263ed8ef418550d413bc75ed40830ed";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/guestmount_1.54.1-1+b1_arm64.deb";
      sha256 = "5b48b6e55e7974a555d48cfb19a56c36fdb7a000a2aac39b42ece8b1bfbe8193";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/guestfish_1.54.1-1+b1_arm64.deb";
      sha256 = "3250e4847a28a659ba268deca0b1be49bda9fb46715cb7424c7015b3ca112b6f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/libguestfs-tools_1.54.1-1+b1_arm64.deb";
      sha256 = "8b86d8c4b9fb296e6b39f49c39a21c610fbce5e2403cfd1bde214b78b925a659";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/linux-base/linux-base_4.11_all.deb";
      sha256 = "b74452838f8460f2c8812430208eeb40788eb782e0c87cf8bb91f3367625bcce";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dracut/dracut-install_106-5_arm64.deb";
      sha256 = "c30e9da5b9c12d3669b9bccbae524f484f2c33a7370ab3bcb26fd50b342f527b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/klibc/libklibc_2.0.13-4_arm64.deb";
      sha256 = "12e4a5651288ec90f144577f564529e1cd8bb9e401c615d86c1abf9924b8994b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/klibc/klibc-utils_2.0.13-4_arm64.deb";
      sha256 = "0711743f9b69fd2e421cf04b785b532360d336c4ee3bcdaeb3a500d6fdd2837f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/initramfs-tools/initramfs-tools-core_0.145_all.deb";
      sha256 = "19f6789f200a9b1ccae87c54a0c74f3a53faedee5030030c9d5e434b40998eac";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/initramfs-tools/initramfs-tools_0.145_all.deb";
      sha256 = "d63e61ea1119a9a539021ec4e2f63bdfc5b6446104e8de7e5d92528dae08920b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/linux-signed-arm64/linux-image-6.12.12-arm64_6.12.12-1_arm64.deb";
      sha256 = "2066e659ed5a81f40e2fa1d3dbadfc203d926c9161f0452ce869659c168e2c11";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/linux-signed-arm64/linux-image-arm64_6.12.12-1_arm64.deb";
      sha256 = "4191a64efad5edb9331e2520fc02c6a52e1fea58b1bd7d900f887bd7e19f01fb";
    })
  ]
]
