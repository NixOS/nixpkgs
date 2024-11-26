{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgff";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "COMBINE-lab";
    repo = "libgff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZCb3UyuB/+ykrYFQ9E5VytT65gAAULiOzIEu5IXISTc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Lightweight GTF/GFF parsers exposing a C++ interface";
    homepage = "https://github.com/COMBINE-lab/libgff";
    downloadPage = "https://github.com/COMBINE-lab/libgff/releases";
    changelog = "https://github.com/COMBINE-lab/libgff/releases/tag/" +
                "v${finalAttrs.version}";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.kupac ];
  };
})
