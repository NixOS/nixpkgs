{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  recode,
  perl,
  rinutils,
  fortune,
  libxslt,
  docbook-xsl-nons,
  shlomif-cmake-modules,
  withOffensive ? false,
}:

stdenv.mkDerivation rec {
  pname = "fortune-mod";
  version = "3.26.0";

  src = fetchFromGitHub {
    owner = "shlomif";
    repo = "fortune-mod";
    tag = "fortune-mod-${version}";
    hash = "sha256-9Tbje6nfIk6SJBVngpurbsr/5PjjriqFYkQqVggWj3Y=";
  };

  sourceRoot = "${src.name}/fortune-mod";

  postPatch = ''
    ln -s ${shlomif-cmake-modules}/lib/cmake/Shlomif_Common.cmake ./cmake/Shlomif_Common.cmake
  '';

  nativeBuildInputs = [
    cmake
    (perl.withPackages (p: [
      p.PathTiny
      p.AppXMLDocBookBuilder
    ]))
    rinutils
    libxslt
    docbook-xsl-nons
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

  meta = {
    mainProgram = "fortune";
    description = "Program that displays a pseudorandom message from a database of quotations";
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ vonfry ];
  };
}
