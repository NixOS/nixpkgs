{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pngoptimizer";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "hadrien-psydk";
    repo = "pngoptimizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J4LY7dTL9dTVGurChKnRz9TdqjaoN0d1fob0v0Nyb8E=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ];

  makeFlags = [
    "CONFIG=release"
    "DESTDIR=$(out)"
  ];

  # Fix build with GCC 15
  env.NIX_CFLAGS_COMPILE = "-Wno-error=old-style-definition";

  postInstall = ''
    mv $out/usr/bin $out/bin
    mv $out/usr/share $out/share
    rmdir $out/usr
  '';

  meta = {
    homepage = "https://psydk.org/pngoptimizer";
    description = "PNG optimizer and converter";
    # https://github.com/hadrien-psydk/pngoptimizer#license-information
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
      zlib
    ];
    maintainers = with lib.maintainers; [ smitop ];
    platforms = with lib.platforms; linux;
  };
})
