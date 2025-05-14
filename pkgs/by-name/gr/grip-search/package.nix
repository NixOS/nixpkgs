{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  boost,
  pkg-config,
  cmake,
  catch2,
}:

stdenv.mkDerivation rec {
  pname = "grip-search";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "sc0ty";
    repo = "grip";
    rev = "v${version}";
    sha256 = "0bkqarylgzhis6fpj48qbifcd6a26cgnq8784hgnm707rq9kb0rx";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    catch2
  ];

  doCheck = true;

  buildInputs = [ boost ];

  patches = [
    # Can be removed after this upstream PR gets merged: https://github.com/sc0ty/grip/pull/6
    (fetchpatch {
      name = "include-cstdint.patch";
      url = "https://github.com/sc0ty/grip/commit/da37b3c805306ee4ea617ce3f1487b8ee9876e50.patch";
      hash = "sha256-Xh++oDn5qn5NPgng7gfeCkO5FN9OmW+8fGhDLpAJfR8=";
    })
  ];

  postPatch = ''
    substituteInPlace src/general/config.h --replace-fail "CUSTOM-BUILD" "${version}"
  '';

  meta = with lib; {
    description = "Fast, indexed regexp search over large file trees";
    homepage = "https://github.com/sc0ty/grip";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ tex ];
  };
}
