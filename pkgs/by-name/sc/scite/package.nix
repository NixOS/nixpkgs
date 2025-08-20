{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scite";
  version = "5.5.4";

  src = fetchurl {
    url = "https://www.scintilla.org/scite${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}.tgz";
    hash = "sha256-Q50DPEUrswv3lS4wOQmRpqvQIqAx6OdLJXF/nkaukKg=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  sourceRoot = "scite/gtk";

  makeFlags = [
    "GTK3=1"
    "prefix=${placeholder "out"}"
  ];

  CXXFLAGS = [
    # GCC 13: error: 'intptr_t' does not name a type
    "-include cstdint"
    "-include system_error"
  ];

  preBuild = ''
    pushd ../../scintilla/gtk
    make ''${makeFlags[@]}
    popd

    pushd ../../lexilla/src
    make ''${makeFlags[@]}
    popd
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.scintilla.org/SciTE.html";
    description = "SCIntilla based Text Editor";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rszibele
      aleksana
    ];
    mainProgram = "SciTE";
  };
})
