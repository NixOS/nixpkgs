{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  openssl,
  buildllvmsparse ? false,
  buildc2xml ? false,
  libllvm,
  libxml2,
}:
let
  version = "1.73";
in
stdenv.mkDerivation {
  pname = "smatch";
  inherit version;

  src = fetchFromGitHub {
    owner = "error27";
    repo = "smatch";
    rev = version;
    sha256 = "sha256-Pv3bd2cjnQKnhH7TrkYWfDEeaq6u/q/iK1ZErzn6bME=";
  };

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isClang [
    "-Wno-incompatible-function-pointer-types"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    openssl
  ] ++ lib.optionals buildllvmsparse [ libllvm ] ++ lib.optionals buildc2xml [ libxml2.dev ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  meta = {
    description = "Semantic analysis tool for C";
    homepage = "https://sparse.docs.kernel.org/";
    maintainers = with lib.maintainers; [ momeemt ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
