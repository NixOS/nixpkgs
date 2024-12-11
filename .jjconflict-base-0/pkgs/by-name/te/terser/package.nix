{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.34.1";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-xbURSt4gBpDVxV5Y9tWfHKAQ7cLt0iAH8VFH6zfboyI=";
  };

  npmDepsHash = "sha256-P2oHKwkDhUvLSUYpzhUxrNKZNGUbyB6KnwYbizHTrew=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
