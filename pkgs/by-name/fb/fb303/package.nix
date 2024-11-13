{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  fbthrift,
  fizz,
  folly,
  glog,
  python3,
  wangle,
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
    sha256 = "sha256-Jtztb8CTqvRdRjUa3jaouP5PFAwoM4rKLIfgvOyXUIg=";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DPYTHON_EXTENSIONS=OFF"
  ];

  buildInputs =
    [
      fbthrift
      fizz
      folly
      glog
      python3
      wangle
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  meta = {
    description = "Base Thrift service and a common set of functionality for querying stats, options, and other information from a service";
    homepage = "https://github.com/facebook/fb303";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kylesferrazza ];
  };
})
