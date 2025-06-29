# This is a generated file.  Do not modify!
# Following are the Debian packages constituting the closure of: base-passwd dpkg libc6-dev perl bash dash gzip bzip2 tar grep mawk sed findutils g++ make curl patch locales coreutils util-linux file dpkg-dev pkg-config login passwd sysvinit diff libguestfs-tools linux-image-amd64 qemu-utils

{ fetchurl }:

[
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/gcc-14-base_14.2.0-17_amd64.deb";
      sha256 = "b8d322fb3099b4e78909bda633ece6cb68d08b52bfabd73b4d89d4ea0af61d58";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libgcc-s1_14.2.0-17_amd64.deb";
      sha256 = "ff4f57b0ce6a82daf6194bf6d9fc6f069858eb4d5e995b0191d7f2d4e45e7344";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc6_2.40-7_amd64.deb";
      sha256 = "5072445cef9e11283bd5aa9ceb3debdc737baf0c93ae77949096ae6fc47a2c96";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cdebconf/libdebconfclient0_0.277_amd64.deb";
      sha256 = "1514f1938db009125c15f343c40d5ea8bd8406837b69bcb7a1785751dbd1762b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pcre2/libpcre2-8-0_10.45-1_amd64.deb";
      sha256 = "f2bd0bcb2a93c27bbac1453c223932ccebfc37b69b899b38dc389b064e4e2257";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libselinux/libselinux1_3.8-4_amd64.deb";
      sha256 = "f2eac6c18f9b2634ec553485bb0bd36e86b14c9ea29cb287cae0bdbd4b95dc77";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/base-passwd/base-passwd_3.6.6_amd64.deb";
      sha256 = "c250bac054d3e5141e06b0dc05370486e775766c829b2a8708d05185bc2641d7";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/acl/libacl1_2.3.2-2+b1_amd64.deb";
      sha256 = "08074f01e384bc07c0c2d79a58cf4a6523f71cf75d1808101c79617656c9a39d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/t/tar/tar_1.35+dfsg-3.1_amd64.deb";
      sha256 = "214c02e1aa291076a3147b8a4c4cae02fadf4c67df629186e3e313726faef1de";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/bzip2/libbz2-1.0_1.0.8-6_amd64.deb";
      sha256 = "cba4cda04244b5e481bb15524bc3c983a7d1b6f330013b9b381706a2fcb65310";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/x/xz-utils/liblzma5_5.6.4-1_amd64.deb";
      sha256 = "55b43990974f36c7bc551839e5f8570bce626e80a78f26f1d45209dc7f9654ae";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libm/libmd/libmd0_1.1.0-2+b1_amd64.deb";
      sha256 = "7244ec3839b61fac0c1884fe08aaa040f26e8f1f35f1f5d3482eacefd30d1b44";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libz/libzstd/libzstd1_1.5.6+dfsg-2_amd64.deb";
      sha256 = "0f34d795fb815c118fea6f88e0c75b8c3ea4e6721982decfab677e726af98844";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/z/zlib/zlib1g_1.3.dfsg+really1.3.1-1+b1_amd64.deb";
      sha256 = "015be740d6236ad114582dea500c1d907f29e16d6db00566ca32fb68d71ac90d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dpkg/dpkg_1.22.15_amd64.deb";
      sha256 = "ba0592e8e1e9e278b3e39a04f9b94edd38193953af9955ae89a553535b854810";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc-dev-bin_2.40-7_amd64.deb";
      sha256 = "33d5598b607638799efe66ba0042c2814ef272874bdae090443474f631485bb3";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxcrypt/libcrypt1_4.4.38-1_amd64.deb";
      sha256 = "0ebc144d662e3197982d1bf3a7b8b35ca845e54c68811de0328b1f0d7c67585c";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxcrypt/libcrypt-dev_4.4.38-1_amd64.deb";
      sha256 = "98e2333aea8d64ca68f9b75c16256d3a05492fd8f9e6dba96adbc6f19e4f5a09";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rpcsvc-proto/rpcsvc-proto_1.4.3-1_amd64.deb";
      sha256 = "32ac0692694f8a34cc90c895f4fc739680fb2ef0e2d4870a68833682bf1c81a3";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc6-dev_2.40-7_amd64.deb";
      sha256 = "90849c9241eae7e687bb615941302485d103e66b61a558cc54b0c7ac50d29f2c";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl/perl-base_5.40.1-2_amd64.deb";
      sha256 = "ef4ca7f03c856a7a7a2c0e532ed7a55e57178eee0240210a8a927095497e54e5";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/db5.3/libdb5.3t64_5.3.28+dfsg2-9_amd64.deb";
      sha256 = "18d02510ee78b67e4504ba050176797a200ff24214a7cd318082ab60ad7bf3fc";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gdbm/libgdbm6t64_1.24-2_amd64.deb";
      sha256 = "e7b42c68c391e278733adb3c1efdacd24d660862bd7bac0efbc10a91e5696dfc";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gdbm/libgdbm-compat4t64_1.24-2_amd64.deb";
      sha256 = "2cbd43cf2dfbf57ff48188b5d79d29cf7ea8f0dedaa61ab0bcc02eceff50ea01";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl/libperl5.40_5.40.1-2_amd64.deb";
      sha256 = "db3085eb8acd8e516b2a9bcfde8d3ca2d31b8b5829d784c4b771e1a77045ba28";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl/perl_5.40.1-2_amd64.deb";
      sha256 = "507219bcb24aadef67b08e0868216cdc768299bbcf275bf8ee127a44e561f771";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/original-awk/original-awk_2025-01-16-1_amd64.deb";
      sha256 = "220e09441ee61bd73cf34502de7505f924b4dc459f4b11ba3c1af8734a5e9254";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/base-files/base-files_13.6_amd64.deb";
      sha256 = "a2fd18c986ea826ddd469565433a314f75334c8cd7907e8620b60e463bea1026";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/debianutils/debianutils_5.21_amd64.deb";
      sha256 = "4224c12ebcd2d8eedbd7981c9f12a3ab35163a039a5c5b667ad465da2d191542";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ncurses/libtinfo6_6.5+20250216-1_amd64.deb";
      sha256 = "41599d794693baaa9ad0197743af422c39a96070214be1214951371220122345";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/bash/bash_5.2.37-1.1_amd64.deb";
      sha256 = "03ae6956930e3724b67965e30a62d6f78cb9e3dc8d06a3d4e8aa70f8d704405e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dash/dash_0.5.12-12_amd64.deb";
      sha256 = "a8902cb6d8650134764a25fb80aec8589d858ef71ece1680a62e84816c37bb04";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gzip/gzip_1.13-1_amd64.deb";
      sha256 = "c98b1130f08ef6ac3932972c56be84cfc308ce1afa37105cb06aaf47ced2d078";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/bzip2/bzip2_1.0.8-6_amd64.deb";
      sha256 = "6b5fbe71f0fc41e85919bc4b3c514e6c47577c5005dbf1f5af6e4a49cc221aab";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/grep/grep_3.11-4_amd64.deb";
      sha256 = "2d78ed07d86a530ebf538f05cb2415f37c8daf908596bc32fc2563cc7e88c55a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mawk/mawk_1.3.4.20250131-1_amd64.deb";
      sha256 = "ade14470c4dff8921bca6ca8b1ea20eadc0f2178b48caff3c74534b17a633292";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sed/sed_4.9-2_amd64.deb";
      sha256 = "50d175d968ee626b1210ef6e8c43c597b912ca30f249f686c0c219532d2a5354";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/findutils/findutils_4.10.0-3_amd64.deb";
      sha256 = "3edf02b016456b6a98cefdbab99c5ce6f829b786f63affe970badea221aecfc7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gmp/libgmp10_6.3.0+dfsg-3_amd64.deb";
      sha256 = "d0d0265eb01770f17afd0f7c8c0622f80479dcfbbe13653a0debeec61464e622";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/isl/libisl23_0.27-1_amd64.deb";
      sha256 = "ac8518042e81c00de1effb72bba7e88ac4ecd488f7ea8b9e3ebc63159cb53b35";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mpfr4/libmpfr6_4.2.1-1+b2_amd64.deb";
      sha256 = "cddb6a0c62c9e17507c0435ca8fa90d2f82fb252144fe38a9ff5a738948d0252";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mpclib3/libmpc3_1.3.1-1+b3_amd64.deb";
      sha256 = "2af0a5c128e03694a41c0b011bd8a958b7297436cdb3a15ddad7866dae8c300b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/cpp-14-x86-64-linux-gnu_14.2.0-17_amd64.deb";
      sha256 = "0cea6826616fa5a6ca6c5d7207e3935881b9959133876af1c86c82c0d7fac31f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/cpp-14_14.2.0-17_amd64.deb";
      sha256 = "c38e01cf093a073ac3cb639cfc7ef212eba5cb9e5a54ce5ec1f66f382ee9d9b9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/cpp-x86-64-linux-gnu_14.2.0-1_amd64.deb";
      sha256 = "d902f484e38bce59e82efc0df2fe20139a0932ca759ecafdfe6e5b6c72238eb8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/cpp_14.2.0-1_amd64.deb";
      sha256 = "a6ba40550aadec80437813e0fce5516574945ff40e72306a5b378c03af3a6544";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libstdc++6_14.2.0-17_amd64.deb";
      sha256 = "93be9f44d060a421d3434fd6d529b3bcb0e672de405062e96f91f92258b0a137";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libcc1-0_14.2.0-17_amd64.deb";
      sha256 = "f948c5f9964f404f19fe7c1cb467d5cfcb7a6e82aacb2f07879bf6304e3986f1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/binutils-common_2.44-2_amd64.deb";
      sha256 = "dee96c9914fe01404d86d8135e7c8f1e44571986bccf8fb2b3f08d0edce08a1b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libsframe1_2.44-2_amd64.deb";
      sha256 = "cf26982a1ef964a6c676981803fe27ac3dc031f13a9a13665fe0a65c6ff223a7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libbinutils_2.44-2_amd64.deb";
      sha256 = "4197f162d7e24e1637faa30eb5ea2b720519b1185afad77768653d383d6e49d7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libctf-nobfd0_2.44-2_amd64.deb";
      sha256 = "d829e9b7a3b3373f5365dc91409e922a4a37ecda2c2ad46e493e640621cb87f6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libctf0_2.44-2_amd64.deb";
      sha256 = "98904992203a68da1935f29a976db5e41adf3b1e51c988c0b4c139a63af408f0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/jansson/libjansson4_2.14-2+b3_amd64.deb";
      sha256 = "60707a62fe6c1228c3389b12a13ca4efd76defc5532473e547a29e99cf7d2a6e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/binutils-x86-64-linux-gnu_2.44-2_amd64.deb";
      sha256 = "fb96edfc9ab8bd6ab930bd5282191c6fdcafad4eac5cdc7c00abf95aebf2e510";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libgomp1_14.2.0-17_amd64.deb";
      sha256 = "9808aebc52e162fd4c294c6495ef57627c2a4544a1608ba4ffac6a4435a38451";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libitm1_14.2.0-17_amd64.deb";
      sha256 = "369579a13af8ea2838549da696ef5411b08c4aa915f28f7596cacb323d31387f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libatomic1_14.2.0-17_amd64.deb";
      sha256 = "3966d347e811300d8ff42aa5b209605ad7870fad74b569ee16a819c1a121aa04";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libasan8_14.2.0-17_amd64.deb";
      sha256 = "7c93c7164ccbd9a776d8f0bba164f28da0e9b90988f2dc56d811d43c045c1da6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/liblsan0_14.2.0-17_amd64.deb";
      sha256 = "27715c4ef3de154900307721020e6c969701f3733e2353d9499bdc4726a6193a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libtsan2_14.2.0-17_amd64.deb";
      sha256 = "44d8aedf33f2b2af98546f6ee616d733202c4b7496da2c2cfa220d4d533cb998";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libubsan1_14.2.0-17_amd64.deb";
      sha256 = "3ffbcae4d1338d7c29513313897b79a9c3bb4691cf7c16dc252e914eeeae033d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libhwasan0_14.2.0-17_amd64.deb";
      sha256 = "35fb531746a7ec93261e37b072f0f0f18943b84ae5ef8e5d9ef875f514d9f4a0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libquadmath0_14.2.0-17_amd64.deb";
      sha256 = "a368e1ddb39220a97de2cafca1511549c8a2430a26ece2bb7c37a2fca9c8d16e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libgcc-14-dev_14.2.0-17_amd64.deb";
      sha256 = "98cc4bae5c9c8b56f92c87cde42af2405ea00fae2617a00ecf64f13507320c16";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/gcc-14-x86-64-linux-gnu_14.2.0-17_amd64.deb";
      sha256 = "a8651cb69bac83682a40a29585f6edf40641d4e818318291b5335b4fb9201b8d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/libgprofng0_2.44-2_amd64.deb";
      sha256 = "5c9e293430abe7a1fa7941090c13b645e7d02811b1d04712034fe9b7b00a9ecf";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/binutils/binutils_2.44-2_amd64.deb";
      sha256 = "9c27921cc8bcd5309f0ff35959e311420a7a8918c09cc0faace57bb2d923bd10";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/gcc-14_14.2.0-17_amd64.deb";
      sha256 = "b816dc3b2880d8dbf3d18f5d17bcccf38b067e2ef660bb831824bcb484c645b4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/gcc-x86-64-linux-gnu_14.2.0-1_amd64.deb";
      sha256 = "04c28c2760b0094b3d7758154ac095303dd00599b63ebad4086a325b607308b7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/gcc_14.2.0-1_amd64.deb";
      sha256 = "eee65c41a441c57c05f754ced1b9d093956966a1c7da9938c3ec00d3dc2f905d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/libstdc++-14-dev_14.2.0-17_amd64.deb";
      sha256 = "2766c7ff14e5e2fff144e86e00a35e4d9240ff57462db6a32b52ba0cf3c96a5d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/g++-14-x86-64-linux-gnu_14.2.0-17_amd64.deb";
      sha256 = "ed02574f34f5b38f8acae602260be252405e29a3d019c241e88e6a96a282c532";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-14/g++-14_14.2.0-17_amd64.deb";
      sha256 = "b15af4b597899da94f600b2ae479d4e02188f45e769f681341ef5027d65e32e7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/g++-x86-64-linux-gnu_14.2.0-1_amd64.deb";
      sha256 = "15e10fc3948ec76be8d51b23e75ad9df9c39588c94f1f47059cee02c117c7583";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gcc-defaults/g++_14.2.0-1_amd64.deb";
      sha256 = "f86661c021ab2acb39ceb87315e7c2d4d420fdadc19945d5d589f3953410445c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/make-dfsg/make_4.4.1-1_amd64.deb";
      sha256 = "4c6db0e3d5f3e990fc0123fe0bc08b4cdaba36f20d01d2fdcea119fb89d59496";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/brotli/libbrotli1_1.1.0-2+b7_amd64.deb";
      sha256 = "0fb79f88db210afbd69282ab9649e525f393ec6950ca34da1a6b359250b8d7db";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nettle/libnettle8t64_3.10.1-1_amd64.deb";
      sha256 = "1b03d4a9cd9c8143ba50fe6396f36937e901a317d492d179f4596862c1731cfe";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nettle/libhogweed6t64_3.10.1-1_amd64.deb";
      sha256 = "b059ed155115ac09da295322de48ee1ed58ef5fa45edcc9e12ff0e94636ef25f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libu/libunistring/libunistring5_1.3-1_amd64.deb";
      sha256 = "db82293b67b63c809bc3cf5ef1b6f1a4bcabd0dde1fdc83c43e47d7f8ca0a267";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libi/libidn2/libidn2-0_2.3.7-2+b1_amd64.deb";
      sha256 = "17fc01829a4951856a2484a7a1fb469baa35337c66dd8095212613e60c357fc8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libf/libffi/libffi8_3.4.7-1_amd64.deb";
      sha256 = "99e28ddc9f6f02a147be07440f0c781bddffe1d59fdb444b242b79f128db3df3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/p11-kit/libp11-kit0_0.25.5-3_amd64.deb";
      sha256 = "784bf2063e166c8bc851a32623b74ebd85c499043a9d57c5bbd64fa63447f45a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libt/libtasn1-6/libtasn1-6_4.20.0-2_amd64.deb";
      sha256 = "296509910b09cfa62608818bd55423bbd27c0542d8176d612afe03521882e830";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gnutls28/libgnutls30t64_3.8.9-2_amd64.deb";
      sha256 = "9fbd2ae6bdadfd96a93eaa192687651e0a545e146e5837c8f082fc7c6f88420b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/krb5/libkrb5support0_1.21.3-4_amd64.deb";
      sha256 = "f82c6d5826c570ef905f5d47dc2e2d6692c6202eee1f4c06392d086461b32cae";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/libcom-err2_1.47.2-1_amd64.deb";
      sha256 = "cc24a08f423d038099b4fa30062643cf719addfb1213110d928064ed9599a7e5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/krb5/libk5crypto3_1.21.3-4_amd64.deb";
      sha256 = "1fcd3b4bd58b9230d0f3c844d6328348410efa64861ba550a5bc0a9b035c246f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/keyutils/libkeyutils1_1.6.3-4_amd64.deb";
      sha256 = "b06a91f5395cc80354df4100b4ce2e3cbe3efb845858c6a063415c7335cfcee2";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openssl/openssl-provider-legacy_3.4.1-1_amd64.deb";
      sha256 = "21645ffde6aadcd6192662455f154f6a789bacfedebfb728e28cc563e958a687";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openssl/libssl3t64_3.4.1-1_amd64.deb";
      sha256 = "95ec621ad83819cae4b2c04fe2b0cfc5bdd90f8e60e687d5803f2956d177fb7e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/krb5/libkrb5-3_1.21.3-4_amd64.deb";
      sha256 = "ff55609ee29d5edc3fa7a0068459cafdaca468f8c783523e4ceb78b88715c06b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/krb5/libgssapi-krb5-2_1.21.3-4_amd64.deb";
      sha256 = "fa81f3a5d93c6ce50855a2f78b022441514cc38b1b78a40a2b97f92036e8c2d7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cyrus-sasl2/libsasl2-modules-db_2.1.28+dfsg1-9_amd64.deb";
      sha256 = "a5c38659fbd62c33c6d9bfa2be43e75a572d1818531aad32dd74d0a58cc4bd19";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cyrus-sasl2/libsasl2-2_2.1.28+dfsg1-9_amd64.deb";
      sha256 = "66e49d7ae026811b49a0050f18b0325960a2625ffd1ff60d91b7844a815fa9d2";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openldap/libldap2_2.6.9+dfsg-1_amd64.deb";
      sha256 = "68c58f4823f7552681822a2de7d5f2059286aac9f59627568e4b6b3d0d0fd05a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nghttp2/libnghttp2-14_1.64.0-1_amd64.deb";
      sha256 = "15bde7d0f62a8f7d819ff32a981dca817f786f71ca922a033775e46ce89c3f67";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nghttp3/libnghttp3-9_1.6.0-2_amd64.deb";
      sha256 = "7100e92e39ddc12a357f22dd81ce9d2e7701ef8559d670c65fca9502f95701e6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ngtcp2/libngtcp2-16_1.9.1-1_amd64.deb";
      sha256 = "146ae8d56997c454a22d3da0b46097279e204b4172688d96ee8306b43240f16f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ngtcp2/libngtcp2-crypto-gnutls8_1.9.1-1_amd64.deb";
      sha256 = "698f6d71821c0000c1cabb3cf019f8e9ae0873e3de0a3d87a04037fbc0f35171";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libp/libpsl/libpsl5t64_0.21.2-1.1+b1_amd64.deb";
      sha256 = "59d42bb1f9ebc0d1776fe616efb08a7a8568b05982e00f70b03c63863db768ab";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rtmpdump/librtmp1_2.4+20151223.gitfa8646d.1-2+b5_amd64.deb";
      sha256 = "93baa2004cbe6c8721b9e81beed078612540aef120970b4751305c51c6697368";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libssh2/libssh2-1t64_1.11.1-1_amd64.deb";
      sha256 = "7cd32dd28148c672f156d1d4ae56d6129bf776980bc6abb4f27c5714c190b958";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/curl/libcurl3t64-gnutls_8.12.1-3_amd64.deb";
      sha256 = "71b3c55ddc7b04a59e899533005e2b31c774825739857b42275baa2aa70b22d3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/curl/curl_8.12.1-3_amd64.deb";
      sha256 = "f3b49b24f56a1a5177b5844d6aa954899a24c8a3ad77c161537adca3e8380918";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/patch/patch_2.7.6-7_amd64.deb";
      sha256 = "8c6d49b771530dbe26d7bd060582dc7d2b4eeb603a20789debc1ef4bbbc4ef67";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glibc/libc-bin_2.40-7_amd64.deb";
      sha256 = "931733c24eee2b5380388f130629d413e353fcdfb3ba146d3a8c2091878fa38e";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/attr/libattr1_2.5.2-3_amd64.deb";
      sha256 = "606b5ee12ea2786be607a17f40c1fb5e65c76ceaff66665bdf8f8c6c1b71d1fb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/coreutils/coreutils_9.5-1+b1_amd64.deb";
      sha256 = "feead508ba503cf90b5fc1fa8e1269cb59325afa53f44185e1d4bb2d9c889b93";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/audit/libaudit-common_4.0.2-2_all.deb";
      sha256 = "b6edcd7aa36a2a5a1abd2c52966d69a99eebdb69c8f5cb33cbf415b0875775e3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcap-ng/libcap-ng0_0.8.5-4+b1_amd64.deb";
      sha256 = "20a9e4b0619a3eb2566338223bed135dde5a601eaa2f8fdd5f20b94506addcac";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/audit/libaudit1_4.0.2-2+b2_amd64.deb";
      sha256 = "e5c200c6f9db0d0e5766c5cad66a686f46c7649868435fba966cdb0be59b42f2";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pam/libpam0g_1.7.0-3_amd64.deb";
      sha256 = "91c8ddb989d1e9bd9f72213c48d5e06b5ac7a730138615326a3587c0449b4143";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcap2/libcap2_2.66-5+b1_amd64.deb";
      sha256 = "2d03c230350e5d19990f604d843a0afc95fd9e554e31a6606bd02c042aaa8a5a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/libsystemd0_257.3-1_amd64.deb";
      sha256 = "cba9428ddffae7d0e5b05f86b8e832af6dfbf3f9326d9742ca8a584a8dfaf478";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pam/libpam-modules-bin_1.7.0-3_amd64.deb";
      sha256 = "b42582a890670b2cfbc8968f9f56513f80941cf16c227cfedb99e0d43d8c0711";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pam/libpam-modules_1.7.0-3_amd64.deb";
      sha256 = "21a718466d15892ec079f816553ad7e95102e2354dfc5756646b0dc1dd4906a7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pam/libpam-runtime_1.7.0-3_all.deb";
      sha256 = "0f19f338c735e2ba51d9448e2dcba195d9698c5829dc864aec9b3b8913bb6f69";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libblkid1_2.40.4-5_amd64.deb";
      sha256 = "3f2601dc1b0e45f2b5ba2b378974571825cdc671de87ce26ecf5d04f45f45913";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libmount1_2.40.4-5_amd64.deb";
      sha256 = "053a3712ea7a195e07e2fc7b92437890da626b7cfa35cba5d73fb212897cbc3d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libsmartcols1_2.40.4-5_amd64.deb";
      sha256 = "bf4cb1af52a9529fd38207f98eb5f50cb9dca5b0b68fc51680cd13932492a5ce";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/libudev1_257.3-1_amd64.deb";
      sha256 = "7fc5163d13ef61b05d7531393d4383c7e8c88834e1d3639adb7b428215281623";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libuuid1_2.40.4-5_amd64.deb";
      sha256 = "b3a1471bf400a28dac5c598600b08e817eed80f6daa027688dad30e1c9f52ddb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/util-linux_2.40.4-5_amd64.deb";
      sha256 = "521ca8021437df8556b5aeb23db7f62fe9a8f73afcb088983ab43c2e74955e08";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/file/libmagic-mgc_5.45-3+b1_amd64.deb";
      sha256 = "a047c138b3d682df665c7dba105d8e0dd416d4a6d76b9bd6cdcd088ca3bac44b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/file/libmagic1t64_5.45-3+b1_amd64.deb";
      sha256 = "aa391a4a96e87e0ce8a4431863bcc7ea4ac21dce141b9fae06b7b362c551198a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/file/file_5.45-3+b1_amd64.deb";
      sha256 = "ece3eae2a764271287990a2f1a08ae073814b303297dfa89bb487c5354248bea";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dpkg/libdpkg-perl_1.22.15_all.deb";
      sha256 = "b77d5fdc901d9057cd558d1b9c34ba4d47a444193ebf7f85957e3dc18cbea9fe";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/x/xz-utils/xz-utils_5.6.4-1_amd64.deb";
      sha256 = "c91874c4dd1b3a7781fa4e06588c275970772461b71404e28f5ca3df8fcc8d39";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dpkg/dpkg-dev_1.22.15_all.deb";
      sha256 = "9ed603f1c79c284b9abc86a6f615f86d1a41ee6d1670ab7311d08df92dcd205e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pkgconf/libpkgconf3_1.8.1-4_amd64.deb";
      sha256 = "85087cd04e57fd4ab7d6e816d348c335047823ab60c78878336b74f07b352ca1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pkgconf/pkgconf-bin_1.8.1-4_amd64.deb";
      sha256 = "54efef2aef4db5fcb5e0f5b7746465000c6a779b06f3686d0ec3d2a901b20aeb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pkgconf/pkgconf_1.8.1-4_amd64.deb";
      sha256 = "f1fcad470ca3ac80b4a0f4af6f03cd215089473996b07e508b3ee342bbb11af7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pkgconf/pkg-config_1.8.1-4_amd64.deb";
      sha256 = "385209ba52e5c97808bbdc2fc4da22aea9020f96fbab6fbfb144921c4a31d400";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/shadow/login.defs_4.17.3-1_all.deb";
      sha256 = "1eba8412effd0c0f2d290b0d00b0dfb73263d6424ae19f904240eb8937b5a76f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/login_4.16.0-2+really2.40.4-5_amd64.deb";
      sha256 = "56ebcb47c3182192bda8c298f023626f2f4d329c8e121d9a7bcc73def5c1548c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libb/libbsd/libbsd0_0.12.2-2_amd64.deb";
      sha256 = "e5a85986fa6bec3307ab1bc860736b478b331882bc45e17675a7bdf88eecb43a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsemanage/libsemanage-common_3.8-1_all.deb";
      sha256 = "28fba03d5c00dd41a57964f265104cce2d820a1f28f2e83e5ac66e529655e602";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsepol/libsepol2_3.8-1_amd64.deb";
      sha256 = "bb951f643c6a9784cc2c8c35ee0e5310ce58bac517a6d2a96797fc7ffa69382f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsemanage/libsemanage2_3.8-1+b1_amd64.deb";
      sha256 = "db4dfd67efe8c9a30724a1b5adf3637db6eee01ed1618e562de948687fc37659";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/shadow/passwd_4.17.3-1_amd64.deb";
      sha256 = "f202db9840986609a265fcde9f0b8356418ca80e0284e3b92ab070e861afff66";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sysvinit/sysvinit-utils_3.14-3_amd64.deb";
      sha256 = "e038a82199b1f377ccabe416342b92ac3894f9b292f6324c3602c83991b35cd1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/insserv/insserv_1.26.0-1_amd64.deb";
      sha256 = "c1e71f879de0226d6da7c8bd1deb10bd79e0667f14c3956f9c1275cb3a329d43";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/startpar/startpar_0.66-1_amd64.deb";
      sha256 = "2e7fe320ed88b1d59484f7beb76331589664eed012d9458aa223e09a4a9d6dd8";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/mount_2.40.4-5_amd64.deb";
      sha256 = "42f0df2bee57b6c8f939f1d6221c92a14763e01d519e59b06d835ab6583be65a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sysvinit/sysvinit-core_3.14-3_amd64.deb";
      sha256 = "f2d2c49cc1977ea8c2e19b0020c65aa19e50c4f13501ec723b0990844dac337a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/diffutils/diffutils_3.10-2_amd64.deb";
      sha256 = "8cb3ed1d4c473cc11ffad83d7ae6d9b232e257accd3173e030c32856c20985f7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/icu/libicu72_72.1-6_amd64.deb";
      sha256 = "bbe2b275aaad89b1a6ee959e31d7b7f3f0af3ac1f97140a7efd2b7b802a11871";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxml2/libxml2_2.12.7+dfsg+really2.9.14-0.2+b2_amd64.deb";
      sha256 = "f1f3e845044f52712ff0d7e6409f5f715167f950750c33e5966b2be1f531382f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/augeas/augeas-lenses_1.14.1-1_all.deb";
      sha256 = "489ab4b8d58fc93937294a54d4c0eb8776c253a9a53500997eca0d9a7f15fce7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/augeas/libaugeas0_1.14.1-1+b3_amd64.deb";
      sha256 = "4ab96ac3bca4a82a2990fdcbee9fb8a0cfeed107776923ac5f9645544b2956df";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/fuse/libfuse2t64_2.9.9-9_amd64.deb";
      sha256 = "e60474070e983693ac461af291b876c2304340f75a6b8379a3ba017e4848341e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/h/hivex/libhivex0_1.3.24-1+b9_amd64.deb";
      sha256 = "1d2c6217b261e8fdc19faddca93cbfe2c3efe60bbee54451026bfbe31d0e3f18";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lua5.3/liblua5.3-0_5.3.6-2+b4_amd64.deb";
      sha256 = "35af63e29e035d7f1ce3586922c51868df86c7fd9a4d28777d80384ad809df61";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/popt/libpopt0_1.19+dfsg-2_amd64.deb";
      sha256 = "07f649b706852af937654295697dcfc7858f3295718ec18681dce1704663e4f2";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libgpg-error/libgpg-error0_1.51-3_amd64.deb";
      sha256 = "01bf2a3cf366f53f4daeab267fc948cefbba0243064ac619c2de21e2fe7a941c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libgcrypt20/libgcrypt20_1.11.0-7_amd64.deb";
      sha256 = "2e228206277d1262e76d5a78098f205edd80ee2c3ee1822ef42cdfdbb98620f9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rpm/librpmio10_4.20.1+dfsg-1_amd64.deb";
      sha256 = "8b5dab731c2b06bb61e9e32453c04dab3b9117d8a3cd591163aaa01648563df8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sqlite3/libsqlite3-0_3.46.1-1_amd64.deb";
      sha256 = "dbc22a2c055d1700d2a3e2a196ca7610678f8152891ca6caa21e7b629bdf3da5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rpm/librpm10_4.20.1+dfsg-1_amd64.deb";
      sha256 = "9daa1b447990a527e0ab4b2c6a19d54024555ddcd9ab303605b9e7617361f4c8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libt/libtirpc/libtirpc-common_1.3.4+ds-1.3_all.deb";
      sha256 = "d31cc2c412789fdd234d6d84b148a5b355d64a2fa3fc21db397a7ccaa64fa7a7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libt/libtirpc/libtirpc3t64_1.3.4+ds-1.3+b1_amd64.deb";
      sha256 = "84a08219066de3a97bc961d5c35964a3bf1758bfa548e8a98032fcfa413c236f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/curl/libcurl4t64_8.12.1-3_amd64.deb";
      sha256 = "dc70e4aaf4a21376a8f5e46eb0fd178b2e9507c73e3652cd68e3ff1b6db1aa83";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/expat/libexpat1_2.6.4-1_amd64.deb";
      sha256 = "8a6088dbcf12540c982ea39e72d5e76aca7e530646feb011fd945a8738c10a87";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/afflib/libafflib0t64_3.7.20-2+b1_amd64.deb";
      sha256 = "2bcca7ddcd61d028e00ab627c5516fb7b839a09922bff367ebe0fad31772456f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libewf/libewf2_20140816-1+b1_amd64.deb";
      sha256 = "e7c64171e71cf1226b7918cfcb84eb3c64819e5833af1770c6510799e90320da";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libv/libvhdi/libvhdi1_20240509-2+b1_amd64.deb";
      sha256 = "e98ad0aa3f084d525b4c1059660e79d47d8ea88e705bfed0e92f6d3a6f955a0a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libv/libvmdk/libvmdk1_20240510-1+b1_amd64.deb";
      sha256 = "59de59843ef26310a3c9b2bde1c409d4d07dbd89841f42d36ba7fb8b6890c6e3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sleuthkit/libtsk19t64_4.12.1+dfsg-3_amd64.deb";
      sha256 = "b3a5446755ba62f6a54b67946c8653b0ddde070bc53608df8c0b974b26de3be9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libv/libvirt/libvirt-common_11.0.0-2_amd64.deb";
      sha256 = "5b20584f1da8ef74303af39c5ac0eeef8eb20fc21819ed1b02a20cab8000555a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/apparmor/libapparmor1_3.1.7-4_amd64.deb";
      sha256 = "711af3f44325355b9f8e777001faf05e98bc5263fc77f329d46d0abdfe2ed930";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glib2.0/libglib2.0-0t64_2.83.4-1_amd64.deb";
      sha256 = "870dc900b0592e6699b5ab27f4f65aac01698f8d148721131ea7e9076c9670b1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/json-c/libjson-c5_0.18+ds-1_amd64.deb";
      sha256 = "4fbd5fb4d54c626f05d68abf38a31533fbf1bf4a87068696abe041ee9c974fe0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libn/libnl3/libnl-3-200_3.7.0-0.3+b1_amd64.deb";
      sha256 = "4489648deb251bbee4b07001a897ec22b8dacf9e87c4c9e667ee5264f9303d0d";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/numactl/libnuma1_2.0.18-1+b1_amd64.deb";
      sha256 = "665f5b01324b94aaa453a0db3f73453e7af812275162e30e7777f21d3470045e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libssh/libssh-4_0.11.1-1_amd64.deb";
      sha256 = "ac16b59e52827962c709b8f1b95521f3a4eb00b0c4723a9bdef50b9daa9b3410";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libv/libvirt/libvirt0_11.0.0-2_amd64.deb";
      sha256 = "59c16e89accaebe3268aae06f9fc3f4be2dd643d81b268cbde4374687881aedc";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/y/yara/libyara10_4.5.2-1_amd64.deb";
      sha256 = "fcb41d8e1aaf6fffece2f40f71aff95f1892e26aeb6c40a6e7b07cc760c80e3c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/libext2fs2t64_1.47.2-1_amd64.deb";
      sha256 = "0f30bc8d520cc0c1597f4e7e7888383a3612915d7f94ea2f5b7431bb2d87c644";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rust-sequoia-sqv/sqv_1.2.1-6+b1_amd64.deb";
      sha256 = "27a7ccd53e924214985c57aeb67420334dcba80db951aeace8299787e099550a";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/x/xxhash/libxxhash0_0.8.3-2_amd64.deb";
      sha256 = "81da7064d56fc044f5db4bb3c1e80ff50a4986dcbbf80d958eeca565b44c157f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lz4/liblz4-1_1.10.0-3_amd64.deb";
      sha256 = "c3572abc2c9fcfe535087ea8df6f69beea7540a52c696dfdafa3e395e3768bdb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/apt/libapt-pkg7.0_2.9.30_amd64.deb";
      sha256 = "7e486334a18d6d9af06a822e93cdbed7ce9452f0af75db638f61c775e5ff3a78";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/debian-archive-keyring/debian-archive-keyring_2023.4_all.deb";
      sha256 = "6e93a87b9e50bd81518880ec07a62f95d7d8452f4aa703f5b0a3076439f1022c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libseccomp/libseccomp2_2.5.5-2+b1_amd64.deb";
      sha256 = "02349908f4e6accc61d86002a88d5beb7f0cb73da7f2dbc10e352bf94cd51f93";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/apt/apt_2.9.30_amd64.deb";
      sha256 = "208733509db3b29696e797fc2a30c3eafc074859e20c55eb7c97aa033596d824";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cpio/cpio_2.15+dfsg-2_amd64.deb";
      sha256 = "d8faece250bcf72e91ac15a5fef198be173af18c9f48bae257e7ee937fbc6cdc";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/logsave_1.47.2-1_amd64.deb";
      sha256 = "f4ab0cace0979bdfad14c8a62164ad37f638960e01997616f17b5798a9f0b5e1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/libss2_1.47.2-1_amd64.deb";
      sha256 = "e8461b2ffe672783d39b1d11b0752944d6f6f58cc5129df22a65ea4c2d82634b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/e2fsprogs/e2fsprogs_1.47.2-1_amd64.deb";
      sha256 = "563b0b745a9c2788de1b3362c0de3aa08bc055d8fd72271488f678d76483306c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/supermin/supermin_5.2.2-6_amd64.deb";
      sha256 = "6152d3e9d17088ed8356b5c0ea45fca8a407ee0343f9fa8af9735c6f56a85949";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/liba/libaio/libaio1t64_0.3.113-8+b1_amd64.deb";
      sha256 = "490c8a2d116001a5f3b0a6d7a7aabf6a7b629366590dc5c3f75b078e931dd129";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/elfutils/libelf1t64_0.192-4_amd64.deb";
      sha256 = "94497b7e17b6f574a0605b380d454e20d3f01a9c63b70c2a2263f679d30053e1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libb/libbpf/libbpf1_1.5.0-2_amd64.deb";
      sha256 = "dcd780edd2dbdae624c396143c2615e2a77b195ebd394de67771c15d0aed5079";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/capstone/libcapstone5_5.0.5-1+b1_amd64.deb";
      sha256 = "837be9f77123893a2c90f0a912377500e03f3fc715d0f29633b07b7f4960822c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/device-tree-compiler/libfdt1_1.7.2-2+b1_amd64.deb";
      sha256 = "8e37034d7864807ae2063efcc82fc79aad59069546212e6e0908ed67f9f7e107";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/fuse3/libfuse3-3_3.14.0-10_amd64.deb";
      sha256 = "1f9513724c18f0587e8ebab2119845d703a312042b679f9cdeeb1ec70c6d089c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/adduser/adduser_3.137_all.deb";
      sha256 = "40b77d8b5b482baee2d0c95bbb4a4b9bcf7271b79dec039ef45e541142edfc12";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libn/libnl3/libnl-route-3-200_3.7.0-0.3+b1_amd64.deb";
      sha256 = "5c87344caa2f72c08d5f9590284b7e9302129968fc255c1451e26bebb4a7e3ca";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rdma-core/libibverbs1_55.0-1_amd64.deb";
      sha256 = "e0af02ee1ee71a709dbc9031eb4f0e4c85654f614c3d79ba9fb25717d885ba45";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libj/libjpeg-turbo/libjpeg62-turbo_2.1.5-3.1_amd64.deb";
      sha256 = "75ce948401245779e0d0f09b558f2bae2daa7c971bdcfa300494fa4b34f26d5b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pixman/libpixman-1-0_0.44.0-3_amd64.deb";
      sha256 = "3862c87596f6b4b60fc916395fd69aa10af28a875a8e5c081a8cf30ddd120bd6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/kmod/libkmod2_33+20240816-2_amd64.deb";
      sha256 = "babb24689d31648baa07d45da56ef249f3a6e7225c4bf61a1e77eba66fdbc6c8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ndctl/libdaxctl1_77-2.2+b2_amd64.deb";
      sha256 = "5f0008db43c846244911168357618ae6f9f6cff00a3f23252f34e299592f3b25";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ndctl/libndctl6_77-2.2+b2_amd64.deb";
      sha256 = "ba955cd5bfbc98c2bbfcf07811b2547bc7f66a38d8d61c0905afaf9eb968150c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pmdk/libpmem1_1.13.1-1.1+b1_amd64.deb";
      sha256 = "7d972d6958e915ce602e4b90debc6b4b91a01dfea1fe003d0b013756e7d9d863";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libp/libpng1.6/libpng16-16t64_1.6.47-1_amd64.deb";
      sha256 = "ba6447e088c324cd3a43c88d7e0a1266cf4aa54602324a65ef39361de2a67062";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/rdma-core/librdmacm1t64_55.0-1_amd64.deb";
      sha256 = "656eb08bb3908b098fe61a6d7c326fd604bd204dd7ea9521e3ff3f1ecadd5187";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libslirp/libslirp0_4.8.0-1+b1_amd64.deb";
      sha256 = "bf69b5be5afac788edc8248ed952c4ad7a279331ba653ef3536d47ef68bd8dd3";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libu/liburing/liburing2_2.9-1_amd64.deb";
      sha256 = "4b589c00c7a51172aace2cb2fb3d3ff32daf86c644023126dcfcaa840cc941ea";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libexecs/libexecs1_1.4-2+b2_amd64.deb";
      sha256 = "05b578fead365a81141fe834c3b3b6df89d17a050784a237f736489fbd426105";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/v/vdeplug4/libvdeplug2t64_4.0.1-5.1+b1_amd64.deb";
      sha256 = "01291e2c8e28e91eac6b59c983a3a44e29ad0ddb8622699fbb84cbd5f26334a4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/alsa-lib/libasound2-data_1.2.13-1_all.deb";
      sha256 = "bac4c89919fcf9f2fad94049312d9368ad0852bffdda1c1be5f353a34916b35f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/alsa-lib/libasound2t64_1.2.13-1+b1_amd64.deb";
      sha256 = "8658243e884021593bdb4458f5240876923949c450f07d8b836c23b395393659";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/brltty/libbrlapi0.8_6.7-1+b2_amd64.deb";
      sha256 = "ccadf991587934b9dd92ec9946fbb32913853dbd96ba85a03b586499bc92d993";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nspr/libnspr4_4.36-1_amd64.deb";
      sha256 = "87fc2039ee89cff2b8010fa9535706b1def40031acfc52bf12197dcb3cb7b064";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/nss/libnss3_3.108-1_amd64.deb";
      sha256 = "921256a4e9d83f40ac0c8a2c083eb1a5f6fae8d7572bd3c233213809a92e9eab";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pcsc-lite/libpcsclite1_2.3.1-1_amd64.deb";
      sha256 = "23f0f5fa1c8887b9a1a5a76c8d33cd189a477ee91f8d86b3ab75d3a7a4bc7c13";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcacard/libcacard0_2.8.0-3+b2_amd64.deb";
      sha256 = "1d6a8d17b893e54dfea8fe78df16c9a8ab4a6e626f9312881784592d480d9317";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ncurses/libncursesw6_6.5+20250216-1_amd64.deb";
      sha256 = "10e49521a83afc11fc5c0ed87133922ee7b490661d08ede4ef1b96bf3ec4c3a4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libu/libusb-1.0/libusb-1.0-0_1.0.27-2_amd64.deb";
      sha256 = "95a0c46bf9ca2a3cf31dbdba77afef56b62f7d511b55dc302c122b9b60b9d1e7";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/usbredir/libusbredirparser1t64_0.15.0-1_amd64.deb";
      sha256 = "4b039802dac140bae5a6f3fb6341eeeb9ea8c3e4d7b95ad36a07a8c28572f177";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/q/qemu/qemu-system-common_9.2.1+ds-1_amd64.deb";
      sha256 = "9730a24c9f4b1703477715c465ce2a335632747cc00146b5279bafddb71deab0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/q/qemu/qemu-system-data_9.2.1+ds-1_all.deb";
      sha256 = "7e5a9506737386a4f3bb7d865253837d8945f6c35a4ed38014c3054aac80a847";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/seabios/seabios_1.16.3-2_all.deb";
      sha256 = "2b590534250b940f43222eeab9a8f57f337a9d9a73fc412a43ab8cd07a7e56f6";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/ipxe/ipxe-qemu_1.21.1+git20250224.12ea8c40+dfsg-2_all.deb";
      sha256 = "aa389ab1fe17bbb2bcc998414fe9b2908ab7b2db03fefd94c82faa0079c5c20f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/q/qemu/qemu-system-x86_9.2.1+ds-1_amd64.deb";
      sha256 = "0a945fc03b2c03610682f736af222b7008f151ce9b9dfaa74324838bbf0acdb9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/q/qemu/qemu-utils_9.2.1+ds-1_amd64.deb";
      sha256 = "135d1bf8756b05102b371f3d0a0f523924513ce132958ee5f61a04622ae74154";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/db5.3/db5.3-util_5.3.28+dfsg2-9_amd64.deb";
      sha256 = "151e292f711229b0d29b359eaa0253958997377569d37e5a8105543346d153e5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/db-defaults/db-util_5.3.4_all.deb";
      sha256 = "1c1bf1d3905c975b55339d3b268ec879658848aee568d5d1ec62635bc1bf23b0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openssl/openssl_3.4.1-1_amd64.deb";
      sha256 = "f940e452145f0e5bca187d33de9636a163fd9c41aadb6d0ce9dbbf0b7d42d7e3";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libencode-perl/libencode-perl_3.21-1+b2_amd64.deb";
      sha256 = "ea20d3d506fc201fec6476e429bb9de8980a734a184ef2c9304950cec8b3c09b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libscalar-list-utils-perl/libscalar-list-utils-perl_1.63-1+b4_amd64.deb";
      sha256 = "93b7ed975d41e50ba78b2c23799baa11242fc5c50d465c6fab2585184aff3e6f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libu/liburi-perl/liburi-perl_5.30-1_all.deb";
      sha256 = "33957bd8218ddd3a86cc19fdf3bf7832b0640337a4be6cf23b2714b73d220220";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhtml-parser-perl/libhtml-parser-perl_3.83-1+b2_amd64.deb";
      sha256 = "a8948f22f77f6f29e5103798de18c740cf1579814dd41a69c30022b3c87bcccc";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libh/libhtml-tree-perl/libhtml-tree-perl_5.07-3_all.deb";
      sha256 = "00f857bb27388432df3e4d6510334a560c2de19feb4b31897cb5d83251bb54ac";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libclone-perl/libclone-perl_0.47-1+b1_amd64.deb";
      sha256 = "c1ca65f05a5fb68b04b4fb0c9f1bd1210c80041c98b0ea7848d80be8bc7a72a5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcompress-raw-bzip2-perl/libcompress-raw-bzip2-perl_2.213-1+b1_amd64.deb";
      sha256 = "8c028b8eb8916707d7d4f47cf695c7088c99c54424b422e811227b7d2b8097f4";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcompress-raw-zlib-perl/libcompress-raw-zlib-perl_2.213-1+b1_amd64.deb";
      sha256 = "761bb8266f128b8e4b413ae4a76dcb01a226a09a8709c1dc676d1783af0e6499";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/perl-openssl-defaults/perl-openssl-defaults_7+b2_amd64.deb";
      sha256 = "e1d601fe96d5465a90042b49921b2086347a2e2111705972ba415ce9f9f3a871";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libn/libnet-ssleay-perl/libnet-ssleay-perl_1.94-3_amd64.deb";
      sha256 = "fc67b418ec1ed7277902702791c91b3023eb488d7c01029f0cc2acfdfdebd13a";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/icoutils/icoutils_0.32.3-6_amd64.deb";
      sha256 = "16a1b2b359ef3d90e9b83b8cf44ce58b11f097c023d02f3bf77745362a6f7247";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/netpbm-free/libnetpbm11t64_11.09.02-2_amd64.deb";
      sha256 = "59c877ae2af31ad8ce159d16cc016f12a719031b8fbffd4240f76e6baa88d353";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libd/libdeflate/libdeflate0_1.23-1+b1_amd64.deb";
      sha256 = "872ca1f7a916c0dc726249e5028c601b045a997cc76a3f251203a0b871eaf141";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/jbigkit/libjbig0_2.1-6.1+b2_amd64.deb";
      sha256 = "95cbc44561651e1b3385454df08e8f2efe84498f6963a85259be2cc2fe798709";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lerc/liblerc4_4.0.0+ds-5_amd64.deb";
      sha256 = "2e0c13c0ddbde12968c2c713c2e0474a5b78e90d5216031256a725e8c76aa31c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libw/libwebp/libsharpyuv0_1.5.0-0.1_amd64.deb";
      sha256 = "51934833d909588f7761fd84362114e90d8d2d38af57edf5df5c4a705e037547";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libw/libwebp/libwebp7_1.5.0-0.1_amd64.deb";
      sha256 = "c749744b04abdd1426b0c7718e516362c03a557c5151662092d6d4f2cef6e7c1";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/t/tiff/libtiff6_4.5.1+git230720-5_amd64.deb";
      sha256 = "2773400039a7c4274ce49a4e3d65f3fedee48bea1562d7014a1f02d32f04345c";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxau/libxau6_1.0.11-1_amd64.deb";
      sha256 = "689a9f0e0ba3e2c65431f864871e303ee904de69dd28abfc462663fae030227f";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxdmcp/libxdmcp6_1.1.5-1_amd64.deb";
      sha256 = "0740dc760916b2008b45417a42a8fd7dd5de370fb57d31373f15034cda8acf0b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxcb/libxcb1_1.17.0-2+b1_amd64.deb";
      sha256 = "5c222a72d11b866447da31693254f738430726e3e065a384e82687b2fd2f978b";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libx11/libx11-data_1.8.10-2_all.deb";
      sha256 = "fe7976c52351e7c403e6beb75a943111bbcd673a13540b85541ca71d1285dde0";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libx11/libx11-6_1.8.10-2_amd64.deb";
      sha256 = "c6299f67cab258bb0c251194f97f0b2301901fb0c53eabbc35bc54f9f5b9c842";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/netpbm-free/netpbm_11.09.02-2_amd64.deb";
      sha256 = "7a856bde1777acd8d26ebcf334423b8fa842a59df8074885ffffdd0c2468ff69";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/osinfo-db/osinfo-db_0.20250124-1_all.deb";
      sha256 = "0c3d3688f5308311adf7d9ab45663eb7cf30d96e49585fcc8cac3bb9d8057658";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/acl/acl_2.3.2-2+b1_amd64.deb";
      sha256 = "fa89b05576c590211c8e8965761fc76b830e3eeb3dd100ac59c8440f11ea18fd";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/a/attr/attr_2.5.2-3_amd64.deb";
      sha256 = "f2eac7412d2df3e36ccea2db110e2fc529a473ce3e348a35ca9c9a521a6bdfb8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/bsdextrautils_2.40.4-5_amd64.deb";
      sha256 = "ca32c48b47944b1f3079d90dd62b9801a112d904444990f226185b15aff81d60";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lzo2/liblzo2-2_2.10-3+b1_amd64.deb";
      sha256 = "f3032201fe2928a87e13f05ce256ff3ac2a7860c7e594dc51ae6d7348a4466ce";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/reiserfsprogs/libreiserfscore0t64_3.6.27-9_amd64.deb";
      sha256 = "138245c2abc72dc0428328da0a5991cae176d51b20552a313f566ccbca7f8a98";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/b/btrfs-progs/btrfs-progs_6.12-1+b1_amd64.deb";
      sha256 = "fc13dc8e210a4b7dd484930770330cdcee6cd9fd58b597cbe5f4f308aa28f624";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/dmsetup_1.02.201-1_amd64.deb";
      sha256 = "f813153c4b6bfa5c6f75aa6c87aba92c40bf7d9c5feaa4c1f944f34b3c0fbfb9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/libdevmapper1.02.1_1.02.201-1_amd64.deb";
      sha256 = "29a68d5d539af88c3c67d45e07a869c94f0cee344d69e994fc3fcac558444542";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cryptsetup/libcryptsetup12_2.7.5-1_amd64.deb";
      sha256 = "92d44ec6d04febd96497d5814a8ac765afcd0bdef5878a304d3d644b69884045";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/c/cryptsetup/cryptsetup-bin_2.7.5-1_amd64.deb";
      sha256 = "b0cd69d8ce90150fa7acaa1d225a6d2f802098bdfbb3af6dba82f31e0ad7c528";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dosfstools/dosfstools_4.2-1.1_amd64.deb";
      sha256 = "937f57ad1efee1d6b284a4378d7705fdf390fee6e3542ee206a89a4d8b93ef60";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/exfatprogs/exfatprogs_1.2.7-3_amd64.deb";
      sha256 = "0b9d0f5cc6f5e6156168a875156508b0c59ab8e382aa002b18057d7496235d49";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/syslinux/extlinux_6.04~git20190206.bf6db5b4+dfsg1-3+b1_amd64.deb";
      sha256 = "43d2cc3947ddc842e535240c4c1f713df407863ab39e430211e3385a7cf0e315";
      name = "extlinux_6.04git20190206.bf6db5b4+dfsg1-3+b1_amd64.deb";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/f2fs-tools/f2fs-tools_1.16.0-1.1+b1_amd64.deb";
      sha256 = "2470227305f92e0399147bd5f74a4b1c423d081a61ce705c0e689f2b408ead9e";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/libfdisk1_2.40.4-5_amd64.deb";
      sha256 = "93ac9a44159ae66ac245d1932470ccac0b0e9fae2b34f7738903d064590b8df5";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/readline/readline-common_8.2-6_all.deb";
      sha256 = "f77e8aa0bf0de618f11cb0b21658a4ed60f177d63b3cf26d7fc3706b6d0eaaa9";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/r/readline/libreadline8t64_8.2-6_amd64.deb";
      sha256 = "eeadf2b5e755c9f183883feea2d9b5b28560284275d5f54d3e55d0923b1d0967";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/fdisk_2.40.4-5_amd64.deb";
      sha256 = "5c59817dfdaa03ba5f29229d97dd20a39b5c39371d2f14caf6aafcfcbffe03c8";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsigsegv/libsigsegv2_2.14-1+b2_amd64.deb";
      sha256 = "bac603b965f303ea88dc39cd723b3d88cd86e3be9c948783f0d5e0d00e971302";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gawk/gawk_5.2.1-2+b1_amd64.deb";
      sha256 = "0e3b376e74cadfa5049bc8248c563efe89fd45e31466f8891c094c65c0879f5c";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gdisk/gdisk_1.0.10-2_amd64.deb";
      sha256 = "a64944b38e8477bf23b9a0ffb6fc653c8847facb1f851864b1a5c40a931456d2";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/efivar/libefivar1t64_38-3.1+b1_amd64.deb";
      sha256 = "34bfb96ca9422af293aeac800438682112b4019adc5ed25728bc35dff4ad4ca4";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/e/efivar/libefiboot1t64_38-3.1+b1_amd64.deb";
      sha256 = "932d5799069e2af3f044cfd615518f0c1539400f1e8e1cdd9eeb407ca213926e";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/freetype/libfreetype6_2.13.3+dfsg-1_amd64.deb";
      sha256 = "1fcf0600356ff0d9b387ad908a897e1e5418705ffb8d7cb66d6dcb25af55b76f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/gettext/gettext-base_0.23.1-1_amd64.deb";
      sha256 = "e6ea4542a54c0a0f7508be4c5830c4a86ff403e336868b4f9531375b4e2c692b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/grub2/grub-common_2.12-5_amd64.deb";
      sha256 = "5ead5a3142700efbf6a8e2dcbd4f283f6e8c61f7b5c815e273f9e26369437a11";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/grub2/grub2-common_2.12-5_amd64.deb";
      sha256 = "4e23feb4c516ce8685e2b60d8940977f9511c1c42496957840f930b2fb6ab4f5";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libm/libmnl/libmnl0_1.0.5-3_amd64.deb";
      sha256 = "4ec9c1096e0b954e3bdb03a62314ee7f49999045d3d55be3e4ded520ffc9baf5";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/iptables/libxtables12_1.8.11-2_amd64.deb";
      sha256 = "4de5aa59faef5e98d6ba9f5f521a915be5641f224f597862f8d29e8319e8db16";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcap2/libcap2-bin_2.66-5+b1_amd64.deb";
      sha256 = "d26a126b4b5f919d24c4f2c2ccb879f40de330149f69b6b39ecd51b45db068d1";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/i/iproute2/iproute2_6.13.0-1_amd64.deb";
      sha256 = "9e75975b198f53947a98624895fb00113278e215457a57f583ebf046ee0cf946";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dhcpcd/dhcpcd-base_10.1.0-7_amd64.deb";
      sha256 = "227ab976f938119c0df15131414b98b4972b1b653ac34161a72faef78f7713fa";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/kmod/kmod_33+20240816-2_amd64.deb";
      sha256 = "1e32699d89a605794962384637412f4409cd5ec8a48735eda216c1e9ed7dcb48";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/j/json-glib/libjson-glib-1.0-0_1.10.6+ds-1_amd64.deb";
      sha256 = "a358ed1c227c35b93073ebae26c71596a725aa3b826e82164bf3ebc0c3cec8ad";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libl/libldm/libldm-1.0-0t64_0.2.5-1.1+b2_amd64.deb";
      sha256 = "2774116e8d441b3c29ad390b969e37b882a40d3d8c1628c4529aaf479155bb35";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libl/libldm/ldmtool_0.2.5-1.1+b2_amd64.deb";
      sha256 = "3862aea5faa6b818fc1f0dc9e133a7aa57ace78a0ab962d27ef2c187b6a6d320";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/less/less_643-1_amd64.deb";
      sha256 = "f9e16accd8a8915abb2a667c5414c6eb99480470ebcc7ff7bf73bdf2b5d34c59";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lsscsi/lsscsi_0.32-2_amd64.deb";
      sha256 = "21cbbe49fa99acdcc910b9e1e9d526b4c1ebc05b9c3767ff67b44395266e540f";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/libdevmapper-event1.02.1_1.02.201-1_amd64.deb";
      sha256 = "53082d383ebb7fa4c8822d5ce5ca7c8e6abef7ff6c765a5d918fdf607e15a450";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libe/libedit/libedit2_3.1-20250104-1_amd64.deb";
      sha256 = "b002ea172b9c1e34a67bc497c523c67bb74c3f0a4e98113cb083990a1f1d3bfe";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/liblvm2cmd2.03_2.03.27-1_amd64.deb";
      sha256 = "13b5e378a130ce5b8a25dc81a31f192fb4684dd7fee40bfaece5c0ff54525145";
    })
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/dmeventd_1.02.201-1_amd64.deb";
      sha256 = "c20707b92c5cfd758ec99286ae6fd3131cc10fc2e1ffdd4b6705cb25432b9ef6";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lvm2/lvm2_2.03.27-1_amd64.deb";
      sha256 = "6735528f862ea38f9c205fde37f8ece6b40bbb0ca3de865020cc308974cb2b12";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/lzop/lzop_1.04-2_amd64.deb";
      sha256 = "84c1650e9cbbe08da100606159d84babcb1da590d244cefb2f0aa66db1a24275";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/libsystemd-shared_257.3-1_amd64.deb";
      sha256 = "ee3052ef71a8e4a7fc2d138bf6197dfc23e97fcb2a3efd7cf2a78dd4d2a820a3";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/systemd_257.3-1_amd64.deb";
      sha256 = "0ec7eb4a5d463d1efab4484f2a9efd1f2c62409c46724116867b53443116830c";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/udev_257.3-1_amd64.deb";
      sha256 = "2de9e505475364486658b2bc05dc2ae38aecb238a9072e189eda18a827b67401";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mdadm/mdadm_4.4-5_amd64.deb";
      sha256 = "7210ac80510ed5683a818c2a2631efabd3c6bb7b20205fbbb1d94c8aa953c8b0";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/m/mtools/mtools_4.0.48-1_amd64.deb";
      sha256 = "e7069109ce49f5a450caeca681e454f24dc412f9fdb289cde54e115162203760";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ntfs-3g/libntfs-3g89t64_2022.10.3-5_amd64.deb";
      sha256 = "e9d61d7b05b794280ff20c25bbd579f5213df44bf1e1a69c77eb9a27adb1a3fe";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/f/fuse3/fuse3_3.14.0-10_amd64.deb";
      sha256 = "922299d9bb8bd464275ff6a4afa30417174f154312c47f08ecb9c4629d028382";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/n/ntfs-3g/ntfs-3g_2022.10.3-5_amd64.deb";
      sha256 = "50d9a768a471da7b221765f8d0795457f1da5dcb984f729bfcc5f78eba33db23";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libcbor/libcbor0.10_0.10.2-2_amd64.deb";
      sha256 = "2457686e375dcb7567ba01da6638a0711e2a55725d084d65de44dd11bb1f52e2";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libf/libfido2/libfido2-1_1.15.0-1+b1_amd64.deb";
      sha256 = "094fc0fe20c652be848ab2a8b3793eb03bc4327140ebd232145356352004e6c0";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/o/openssh/openssh-client_9.9p2-1_amd64.deb";
      sha256 = "e010d4b64889bb54f601dd297997a816b5e807268e5d1e09a8474e839d918733";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dmidecode/dmidecode_3.6-2_amd64.deb";
      sha256 = "6ad5a5483752ea05e425e77adc9ccf58ce9da22cca28d8932ea316d641f199d3";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/parted/libparted2t64_3.6-5_amd64.deb";
      sha256 = "65bc42f046f51f01152da1c6b48f7b65d2e84bc0b04c0da29c33bded87217a36";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/parted/parted_3.6-5_amd64.deb";
      sha256 = "fbb8429783a8dd065bf9c37e249acaa56cb7bb8a3ff5bb531ef0aac3e8945f2d";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pciutils/libpci3_3.13.0-2_amd64.deb";
      sha256 = "f8f01883368fe86417b3845aa08ea3508ca59f5e1bb0983673629e227f5ac868";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/pciutils/pciutils_3.13.0-2_amd64.deb";
      sha256 = "bd0e35ccc3378825b7b5f967e1eae687850025a91a49b055e433f1522bfa80f6";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/procps/libproc2-0_4.0.4-7_amd64.deb";
      sha256 = "1c19babbc9cf029e8a1faf259a9f0d7b69b16a940f31e43cd6c175b6eb167e2e";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/procps/procps_4.0.4-7_amd64.deb";
      sha256 = "730a3f345977c90756fed89e39bff832316da7d637f40ba2e42516c480279f20";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/p/psmisc/psmisc_23.7-2_amd64.deb";
      sha256 = "19e772bca5ad0b28620229fe4f91383044c5c6322c7c50ae46da1c60d73d9960";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/scrub/scrub_2.6.1+git20240819.9b4267e-1_amd64.deb";
      sha256 = "95de3e58c844027cec4b8c05c1b0ea6ee99b9ece094cdae99300d3774b2b92c3";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libb/libbfio/libbfio1_20170123-6+b2_amd64.deb";
      sha256 = "c64c853f42df88409c54d08b8b43d631fbb25264eee17dc92042538ca73b0715";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/sleuthkit/sleuthkit_4.12.1+dfsg-3_amd64.deb";
      sha256 = "47df7313141f5dd244ed8777cbf9985925c6b161e38293868deb60ca0f324423";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/squashfs-tools/squashfs-tools_4.6.1-1_amd64.deb";
      sha256 = "0e185122f5858132bbc709e26228ba28cf7f0c41f6ed26e3f55f518f2a53b59d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/syslinux/syslinux_6.04~git20190206.bf6db5b4+dfsg1-3+b1_amd64.deb";
      sha256 = "07a34a8b09e19ef44285d45c24aefd1119cf3c1580223cbca0dc58f8dd33ee33";
      name = "syslinux_6.04git20190206.bf6db5b4+dfsg1-3+b1_amd64.deb";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/systemd-sysv_257.3-1_amd64.deb";
      sha256 = "3210e945a631381edefb61dc5ba29b3d900cbb0b5fbea9ab4f295b9c68cc3134";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/util-linux-extra_2.40.4-5_amd64.deb";
      sha256 = "a731cd11bb4c12357d244732be0450c98aa0441566773aa2c66f082833752647";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/u/util-linux/uuid-runtime_2.40.4-5_amd64.deb";
      sha256 = "227f1d81091e8f2e6bc35972d42d47c4b5902fcdda50ba2ad239274f0afaa6c0";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/z/zerofree/zerofree_1.1.1-1+b1_amd64.deb";
      sha256 = "68775644c1351319a236528299e8ea5fa20984139fa769c977b0b6716d687943";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libz/libzstd/zstd_1.5.6+dfsg-2_amd64.deb";
      sha256 = "57bba0e724ee6e9849d2ca53f5252b4f0d4a3fb7162b41e7783303efa548b0b3";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/libguestfs0t64_1.54.1-1+b1_amd64.deb";
      sha256 = "cc3d055f7a6ffe4be9fe04300758ae26683615a2b9c684f4d22902db40c1adea";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/duktape/libduktape207_2.7.0-2+b2_amd64.deb";
      sha256 = "2d92606f49cf79e23fb4ea67ab7702d52e016a671d32edc51482c4f1e3bade7c";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libp/libproxy/libproxy1v5_0.5.9-1_amd64.deb";
      sha256 = "794a8526989464cb17f1dec9dab921f0e5afb82bcc665e938fac925be47698eb";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glib-networking/glib-networking-services_2.80.1-1_amd64.deb";
      sha256 = "545f6d24809a79f3b527ec37c30dee0b2c3b18c1466e7983d8e7b0a2cc3a4431";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/libdbus-1-3_1.16.2-1_amd64.deb";
      sha256 = "82d86bf84d14d2707fabfb07cc0e4140e7f07cf59471a7cc17545db77f04fcd1";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus-bin_1.16.2-1_amd64.deb";
      sha256 = "b295c0ff60db1ab0698b617530bcc70147dcbdb6fa72bf7ce23b7b85b347c1e1";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus-daemon_1.16.2-1_amd64.deb";
      sha256 = "d29227c2021778182eccf423624af1aa8888847ac9ab9aafc1e1ea4f7ac4eb2c";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus_1.16.2-1_amd64.deb";
      sha256 = "49bbb4a13667b53fd180b4f596774b4d52fc2b0ea28f30c2fb6c8c8ab58d85ae";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/s/systemd/libpam-systemd_257.3-1_amd64.deb";
      sha256 = "b0fadeb1050028676def4a20669d56d783d057c109122661db66038497ed0a9b";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dbus/dbus-user-session_1.16.2-1_amd64.deb";
      sha256 = "b804e07c8c0809f58722c7d8b03fcc561a495bdb40d57b6bd74e1757874d9d33";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dconf/libdconf1_0.40.0-5_amd64.deb";
      sha256 = "6e7f670e1cf493ae8f60dea52f5a4aef56605d5b06d921113d7c2a2800ff5af1";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dconf/dconf-service_0.40.0-5_amd64.deb";
      sha256 = "4a1feeda4605be8561ec32fb4d0655fbe2313e62e457107168f528d959b530b8";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dconf/dconf-gsettings-backend_0.40.0-5_amd64.deb";
      sha256 = "393e8deffcc78d4396e860f10cb5e7d0aab448d6e0965add62941fcd27be00fb";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/glib-networking/glib-networking_2.80.1-1_amd64.deb";
      sha256 = "183829044aa67f7e8c41a407dcee71d446da0ed3c87113689603a27007099137";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsoup3/libsoup-3.0-0_3.6.4-2_amd64.deb";
      sha256 = "5bf081b9ef44a51aab23e253f4542f2e330439d8f3cc1c6aea16f410d57a1893";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxslt/libxslt1.1_1.1.35-1.1+b1_amd64.deb";
      sha256 = "1e5a8045452db38ab50d86c6acd047004aee704e38937a8474251d58b81c8669";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libo/libosinfo/libosinfo-1.0-0_1.12.0-2_amd64.deb";
      sha256 = "cd3a482babcabba0817c66d7f004d6379d5072ce14efe827572678e410025ae5";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libx/libxml-parser-perl/libxml-parser-perl_2.47-1+b3_amd64.deb";
      sha256 = "030a808e359a851c6c712044158c261d44f52c3d3bdeefaedaef96f9da0dd94d";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/h/hivex/libwin-hivex-perl_1.3.24-1+b9_amd64.deb";
      sha256 = "66ce82efa04011c71460f204353e29d946112e49d936e1f32f4e8db0e96d01c4";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libs/libsys-virt-perl/libsys-virt-perl_11.0.0-1_amd64.deb";
      sha256 = "1ca45ee9c72f04e2b651b496c4abf99cf25beba2b38c32db7790377ebc0d122d";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/libguestfs-perl_1.54.1-1+b1_amd64.deb";
      sha256 = "2e6c3669b995eccf7b471167bb311635681ea96a8be002b1758f85f0aebad894";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/g/guestfs-tools/guestfs-tools_1.52.2-4_amd64.deb";
      sha256 = "4897c4137f0070adbb84fd0f9e726e36ff2204af9b886f1a032316cba16057ec";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libc/libconfig/libconfig11_1.7.3-2_amd64.deb";
      sha256 = "0609351b0069ef47f9ade42625a760f8889aeb55bd7107339f61a4abf9a4068e";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/guestmount_1.54.1-1+b1_amd64.deb";
      sha256 = "3d559b24e38deb89de800fea6c3a9246d5a79706fc64243c7a67a26de1729410";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/guestfish_1.54.1-1+b1_amd64.deb";
      sha256 = "5f15f7ba3526a3d74fd21e0967c04cb61ce65f68ace6ac3cd0f3a52e3dc63d78";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/libg/libguestfs/libguestfs-tools_1.54.1-1+b1_amd64.deb";
      sha256 = "947d26d11215f87a0798005894f692c91b1e8e8bc3a2b97e58dc3c0542e33945";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/d/dracut/dracut-install_106-5_amd64.deb";
      sha256 = "a7fff057e89a64acf829977f484aef7276ea7b3443d7b2c141991ff5aae3c096";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/klibc/libklibc_2.0.13-4_amd64.deb";
      sha256 = "39733ce0d80c5042ce3569a3d0594f585f0a60889e4e9eb2cccc486182c18b74";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/k/klibc/klibc-utils_2.0.13-4_amd64.deb";
      sha256 = "d087c9c1ff0115c103203c1d04b2ef609c70dfe9fbc6441569b7133c4ff0fdd0";
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
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/linux-signed-amd64/linux-image-6.12.12-amd64_6.12.12-1_amd64.deb";
      sha256 = "00822f6af7202dbb7b45c02e36db3dbd23bd98f0f97e72483749fb595dae220e";
    })
  ]
  [
    (fetchurl {
      url = "https://snapshot.debian.org/archive/debian/20250305T144614Z/pool/main/l/linux-signed-amd64/linux-image-amd64_6.12.12-1_amd64.deb";
      sha256 = "da0ae1dba152e6cb9082f066a51a3df768d82b31d146b8dda224ed467012a633";
    })
  ]
]
