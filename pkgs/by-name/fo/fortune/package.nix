{
  lib,
  stdenv,
  fetchurl,
  cmake,
  recode,
  perl,
  rinutils,
  fortune,
  libxslt,
  docbook-xsl-nons,
  withOffensive ? false,
}:

stdenv.mkDerivation rec {
  pname = "fortune-mod";
  version = "3.26.0";

  # We use fetchurl instead of fetchFromGitHub because the release pack has some
  # special files.
  src = fetchurl {
    url = "https://github.com/shlomif/fortune-mod/releases/download/fortune-mod-${version}/fortune-mod-${version}.tar.xz";
    sha256 = "sha256-rE0UhsrJuZkEkQcTa5QQb+mKSurADsY1sUTEN2S//kw=";
  };

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
