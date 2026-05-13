{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libGLU,
  libGL,
  qt6,
  boost,
  ninja,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  version = "202507";
  build_nr = "0";
  pname = "mcrl2";

  src = fetchurl {
    url = "https://www.mcrl2.org/download/release/mcrl2-${version}.${build_nr}.tar.gz";
    hash = "sha256-Ur7GGXbYvVmrEUq/CTRyuVNLDHKfFrYHJibo0JvYhyM=";
  };

  postInstall = lib.optional stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/mCRL2.app $out/Applications
    mkdir $out/bin
    makeWrapper "$out/Applications/mCRL2.app/Contents/MacOS/mCRL2" "$out/bin/mcrl2ide"
  '';

  postFixup = lib.optional stdenv.hostPlatform.isDarwin ''
    APP_DIR="$out/Applications/mCRL2.app/Contents"
    find "$APP_DIR/lib" -name "*.dylib" | while read lib; do
      install_name_tool -id "@rpath/$(basename "$lib")" "$lib" || true
      otool -L "$lib" | grep "$out" | awk '{print $1}' | while read old_path; do
        install_name_tool -change "$old_path" "@rpath/$(basename "$old_path")" "$lib" || true
      done
    done
    find "$APP_DIR/bin" -type f | while read bin; do
      install_name_tool -add_rpath "@loader_path/../lib" "$bin" || true
      otool -L "$bin" | grep "$out" | awk '{print $1}' | while read old_path; do
        libname=$(basename "$old_path")
        install_name_tool -change "$old_path" "@rpath/$libname" "$bin" || true
      done
    done
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libGLU
    libGL
    qt6.qtbase
    boost
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [ makeWrapper ];

  dontWrapQtApps = true;

  meta = {
    description = "Toolset for model-checking concurrent systems and protocols";
    longDescription = ''
      A formal specification language with an associated toolset,
      that can be used for modelling, validation and verification of
      concurrent systems and protocols
    '';
    homepage = "https://www.mcrl2.org/";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ moretea ];
    platforms = lib.platforms.unix;
  };
}
