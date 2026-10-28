{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgrapheme";
  version = "3.0.0";

  src = fetchurl {
    url = "https://dl.suckless.org/libgrapheme/libgrapheme-${finalAttrs.version}.tar.gz";
    hash = "sha256-Mlha9z3aYvvMD+0U8ZmqG8mIrQHa0L+9Bs8XXZzz1ow=";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace-fail "uname" "echo ${stdenv.hostPlatform.uname.system}"
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  makeFlags = [
    "AR:=$(AR)"
    "CC:=$(CC)"
    "RANLIB:=$(RANLIB)"
    "BUILD_CC=$(CC_FOR_BUILD)"
  ];

  installFlags = [
    "PREFIX=$(out)"
    "LDCONFIG="
  ];

  meta = {
    description = "Unicode string library";
    homepage = "https://libs.suckless.org/libgrapheme/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
})
