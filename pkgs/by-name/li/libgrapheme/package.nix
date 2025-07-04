{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "libgrapheme";
  version = "2.0.2";

  src = fetchurl {
    url = "https://dl.suckless.org/libgrapheme/libgrapheme-${version}.tar.gz";
    hash = "sha256-pou93edr1Vul1kEWzl5CoT3wRcgcCFLemrYIlqoUMSU=";
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

  meta = with lib; {
    description = "Unicode string library";
    homepage = "https://libs.suckless.org/libgrapheme/";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
