{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrss: {
  version = "2.8.7";
  pname = "tinygltf";

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    tag = "v${finalAttrss.version}";
    hash = "sha256-uQlv+mUWnqUJIXnPf2pVuRg1akcXAfqyBIzPPmm4Np4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Header only C++11 tiny glTF 2.0 library";
    homepage = "https://github.com/syoyo/tinygltf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jansol ];
    platforms = lib.platforms.all;
  };
})
