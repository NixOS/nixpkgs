{ lib, stdenv, fetchurl, libuuid, autoreconfHook, e2fsprogs, acl }:

stdenv.mkDerivation rec {
  pname = "reiserfsprogs";
  version = "3.6.27";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v${version}/${pname}-${version}.tar.xz";
    hash = "sha256-DpW2f6d0ajwtWRRem5wv60pr5ShT6DtJexgurlCOYuM=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libuuid e2fsprogs acl ];

  env.NIX_CFLAGS_COMPILE = toString [ "-std=gnu90" "-D_GNU_SOURCE" ];

  meta = {
    inherit version;
    homepage = "http://www.namesys.com/";
    description = "ReiserFS utilities";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
