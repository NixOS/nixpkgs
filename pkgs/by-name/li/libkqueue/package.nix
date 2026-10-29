{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkqueue";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "mheily";
    repo = "libkqueue";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hT7/0Cy4UCKN16Rlwyjj1AAYC4/n1+170xsnYrjiglQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "kqueue(2) compatibility library";
    homepage = "https://github.com/mheily/libkqueue";
    changelog = "https://github.com/mheily/libkqueue/raw/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
