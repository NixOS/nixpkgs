{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,

  glog,
  folly,
  fbthrift,
  fizz,
  wangle,
  python3,
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fb303";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fb303";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Jtztb8CTqvRdRjUa3jaouP5PFAwoM4rKLIfgvOyXUIg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [
      glog
      folly
      fbthrift
      fizz
      wangle
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  cmakeFlags = [
    "-DPYTHON_EXTENSIONS=OFF"
  ];

  meta = {
    description = "Base Thrift service and a common set of functionality for querying stats, options, and other information from a service";
    homepage = "https://github.com/facebook/fb303";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kylesferrazza ];
  };
})
