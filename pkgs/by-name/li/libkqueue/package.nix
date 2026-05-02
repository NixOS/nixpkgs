{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkqueue";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "mheily";
    repo = "libkqueue";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Lex/EmVMESScungJ6r/Br7TaoC4fcDHvDBJpryoe84E=";
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
