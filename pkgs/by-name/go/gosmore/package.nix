{
  lib,
  stdenv,
  fetchFromGitHub,
  libxml2,
  gtk2,
  curl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gosmore";
  version = "0-unstable-2014-03-17";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "svn-archive";
    rev = "89b1fbfbc9e9a8b5e78795fd40bdfa60550322fc";
    sparseCheckout = [ "applications/rendering/gosmore" ];
    hash = "sha256-MfuJVsyGWspGNAFD6Ktbbyawb4bPwUITe7WkyFs6JxI=";
  };

  sourceRoot = "${finalAttrs.src.name}/applications/rendering/gosmore";

  buildInputs = [
    libxml2
    gtk2
    curl
  ];

  nativeBuildInputs = [ pkg-config ];

  prePatch = ''
    sed -e '/curl.types.h/d' -i *.{c,h,hpp,cpp}
    sed -e "24i #include <ctime>" -e "s/data/dat/g" -i jni/libgosm.cpp
  '';

  patches = [ ./pointer_int_comparison.patch ];
  patchFlags = [
    "-p1"
    "--binary"
  ]; # patch has dos style eol

  meta = {
    description = "Open Street Map viewer";
    mainProgram = "gosmore";
    homepage = "https://sourceforge.net/projects/gosmore/";
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
  };
})
