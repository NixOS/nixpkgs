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
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "jkbonfield";
    repo = "io_lib";
    rev = "io_lib-" + builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-2Dlx+MXmqar81/Xmf0oE+6lWX461EDYijiZsZf/VD28=";
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
