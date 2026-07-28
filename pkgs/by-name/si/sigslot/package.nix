{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sigslot";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "palacaze";
    repo = "sigslot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8JBZ6Xid/uAOfiPKgJKetpj/oBb8lRLPgjkMnrfTKaM=";
  };

  nativeBuildInputs = [ cmake ];

  dontBuild = true;

  meta = {
    description = "Header-only, thread safe implementation of signal-slots for C++";
    license = lib.licenses.mit;
    homepage = "https://github.com/palacaze/sigslot";
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.all;
  };
})
