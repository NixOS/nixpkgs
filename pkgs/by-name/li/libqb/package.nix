{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqb";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = "libqb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3lXieKy3JqvuAIzXQjq6kDMfMmokXR/v3p4VQDIuOI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libxml2 ];

  # Remove configure check for linker flag `--enable-new-dtags`, which fails
  # on darwin. The flag is never used by the Makefile anyway.
  postPatch = ''
    sed -i '/# --enable-new-dtags:/,/esac/ d' configure.ac
  '';

  meta = {
    homepage = "https://github.com/clusterlabs/libqb";
    description = "Library providing high performance logging, tracing, ipc, and poll";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
