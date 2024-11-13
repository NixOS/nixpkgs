{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  folly,
  glog,
  gtest,
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edencommon";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "edencommon";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1z4QicS98juv4bUEbHBkCjVJHEhnoJyLYp4zMHmDbMg=";
  };

  patches = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Test discovery timeout is bizarrely flaky on `x86_64-darwin`
    ./increase-test-discovery-timeout.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [
      glog
      folly
      gtest
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  meta = with lib; {
    description = "Shared library for Meta's source control filesystem tools (EdenFS and Watchman)";
    homepage = "https://github.com/facebookexperimental/edencommon";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kylesferrazza ];
  };
})
