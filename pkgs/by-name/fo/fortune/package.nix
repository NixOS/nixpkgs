{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  recode,
  perl,
  rinutils,
  fortune,
  shlomif-cmake-modules,
  libxslt,
  docbook-xsl-ns,
  docbook-xsl-nons,
  withOffensive ? false,
}:

stdenv.mkDerivation rec {
  pname = "fortune-mod";
  version = "3.24.0";

  src = fetchFromGitHub {
    owner = "shlomif";
    repo = "fortune-mod";
    tag = "fortune-mod-${version}";
    hash = "sha256-kuaaSmTWR8HXIU/fRSrUChh4XFEUPIw1LeXvwagX8KY=";
  };

  sourceRoot = "${src.name}/fortune-mod";

  postPatch = ''
    ln -s ${shlomif-cmake-modules}/lib/cmake/Shlomif_Common.cmake ./cmake/Shlomif_Common.cmake
  '';

  nativeBuildInputs = [
    cmake
    libxslt
    docbook-xsl-ns
    docbook-xsl-nons
    (perl.withPackages (p: [
      p.PathTiny
      p.AppXMLDocBookBuilder
    ]))
    rinutils
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    # "strfile" must be in PATH for cross-compiling builds.
    fortune
  ];

  buildInputs = [ recode ];

  cmakeFlags = [
    "-DLOCALDIR=${placeholder "out"}/share/fortunes"
  ]
  ++ lib.optional (!withOffensive) "-DNO_OFFENSIVE=true";

  patches = [
    (builtins.toFile "not-a-game.patch" ''
      diff --git a/CMakeLists.txt b/CMakeLists.txt
      index 865e855..5a59370 100644
      --- a/CMakeLists.txt
      +++ b/CMakeLists.txt
      @@ -154,7 +154,7 @@ ENDMACRO()
       my_exe(
           "fortune"
           "fortune/fortune.c"
      -    "games"
      +    "bin"
       )

       my_exe(
      --
    '')
  ];

  postFixup = lib.optionalString (!withOffensive) ''
    rm $out/share/games/fortunes/men-women*
  '';

  meta = with lib; {
    mainProgram = "fortune";
    description = "Program that displays a pseudorandom message from a database of quotations";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vonfry ];
  };
}
