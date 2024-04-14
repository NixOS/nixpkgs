{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsoncons";
  version = "0.173.4";

  src = fetchFromGitHub {
    owner = "danielaparker";
    repo = "jsoncons";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Mf3kvfYAcwNrwbvGyMP6PQmk5e5Mz7b0qCZ6yi95ksk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A C++, header-only library for constructing JSON and JSON-like data formats";
    homepage = "https://danielaparker.github.io/jsoncons/";
    changelog = "https://github.com/danielaparker/jsoncons/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
})
