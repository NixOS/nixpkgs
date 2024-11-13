{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,

  fizz,
  folly,
  gflags,
  glog,
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mvfst";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "mvfst";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-KjNTDgpiR9EG42Agl2JFJoPo5+8GlS27oPMWpdLq2v8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [
      fizz
      folly
      gflags
      glog
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  meta = {
    description = "Implementation of the QUIC transport protocol";
    homepage = "https://github.com/facebook/mvfst";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ris ];
  };
})
