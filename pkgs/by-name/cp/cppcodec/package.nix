{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppcodec";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tplgy";
    repo = "cppcodec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k4EACtDOSkTXezTeFtVdM1EVJjvGga/IQSrvDzhyaXw=";
  };

  patches = [
    # CMake 2.8 is deprecated and is no longer supported by CMake > 4
    # https://github.com/NixOS/nixpkgs/issues/445447
    # Luckily, this has been fixed on master.
    (fetchpatch {
      name = "modernize-cmake.patch";
      url = "https://github.com/tplgy/cppcodec/commit/8019b8b580f8573c33c50372baec7039dfe5a8ce.patch";
      hash = "sha256-0MCx3nTsey4Qonx+lyexbcxut0qIHOJZbkJ9u23Zuv8=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Header-only C++11 library for encode/decode functions as in RFC 4648";
    longDescription = ''
      Header-only C++11 library to encode/decode base64, base64url, base32,
      base32hex and hex (a.k.a. base16) as specified in RFC 4648, plus
      Crockford's base32.
    '';
    homepage = "https://github.com/tplgy/cppcodec";
    license = licenses.mit;
    maintainers = with maintainers; [
      panicgh
      raitobezarius
    ];
  };
})
