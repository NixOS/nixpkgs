{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cl-launch";
  version = "4.1.4.1";

  src = fetchurl {
    url = "http://common-lisp.net/project/xcvb/cl-launch/cl-launch-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-v5aURs2Verhn2HmGiijvY9br20OTPFrOGBWsb6cHhSQ=";
  };

  preConfigure = ''
    mkdir -p "$out/bin"
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preBuild = ''
    sed -e 's/\t\t@/\t\t/g' -i Makefile
  '';

  meta = {
    description = "Common Lisp launcher script";
    license = lib.licenses.llgpl21;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
