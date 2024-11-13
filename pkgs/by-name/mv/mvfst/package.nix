{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,

  fizz,
  folly,
  gflags,
  glog,
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mvfst";
  version = "2024.11.18.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "mvfst";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-2Iqk6QshM8fVO65uIqrTbex7aj8ELNSzNseYEeNdzCY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

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
