{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsoncons";
  version = "0.177.0";

  src = fetchFromGitHub {
    owner = "danielaparker";
    repo = "jsoncons";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zRFLj8uBNAdirvJlsbrdGfn6cfNpYLUDctcy6RN8Z8U=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++, header-only library for constructing JSON and JSON-like data formats";
    homepage = "https://danielaparker.github.io/jsoncons/";
    changelog = "https://github.com/danielaparker/jsoncons/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
})
