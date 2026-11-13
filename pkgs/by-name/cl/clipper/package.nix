{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.4.2";
  pname = "Clipper";
  src = fetchurl {
    url = "mirror://sourceforge/polyclipping/clipper_ver${finalAttrs.version}.zip";
    sha256 = "09q6jc5k7p9y5d75qr2na5d1gm0wly5cjnffh127r04l47c20hx1";
  };

  sourceRoot = "cpp";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.6.0)" "CMAKE_MINIMUM_REQUIRED(VERSION 3.10.0)"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    unzip
  ];

  meta = {
    description = "Polygon and line clipping and offsetting library (C++, C#, Delphi)";
    longDescription = ''
      The Clipper library performs line & polygon clipping - intersection, union, difference & exclusive-or,
      and line & polygon offsetting. The library is based on Vatti's clipping algorithm.
    '';
    homepage = "https://sourceforge.net/projects/polyclipping";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ mpickering ];
    platforms = with lib.platforms; unix;
  };
})
