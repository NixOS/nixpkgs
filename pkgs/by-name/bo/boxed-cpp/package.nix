{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "boxed-cpp";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "boxed-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uZ/wT159UuEcTUtoQyt0D59z2wnLT5KpeeCpjyij198=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ catch2 ];

  meta = {
    description = "Boxing primitive types in C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.moni ];
  };
})
