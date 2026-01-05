{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  bzip2,
  xz,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  # Same name as the Debian library
  pname = "libstaden-read";
  version = "1-15-1";

  src = fetchFromGitHub {
    owner = "jkbonfield";
    repo = "io_lib";
    tag = "io_lib-" + builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-X96gFrefH2NAp4+fvVLXHP9FbF04gQOWLm/tAFJPgR8=";
  };

  patches = [
    # Needed so that the lib can be detected
    ./libstaden-install-config-header.patch
  ];

  buildInputs = [
    bzip2
    xz
    zlib
  ];
  nativeBuildInputs = [ autoreconfHook ];

  # autoreconfHook does not descend into htscodecs folder
  preAutoreconf = ''
    pushd ./htscodecs
    autoreconf --install --force --verbose
    pushd
  '';

  meta = {
    description = "C library for reading/writing various DNA sequence formats";
    homepage = "https://staden.sourceforge.net";
    downloadPage = "https://github.com/jkbonfield/io_lib/releases";
    changelog = "https://github.com/jkbonfield/io_lib/blob/${finalAttrs.src.rev}/CHANGES";
    license = with lib.licenses; [
      bsd3
      free
    ];
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.kupac ];
  };
})
