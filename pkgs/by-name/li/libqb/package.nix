{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "libqb";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = "libqb";
    tag = "v${version}";
    hash = "sha256-e3lXieKy3JqvuAIzXQjq6kDMfMmokXR/v3p4VQDIuOI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libxml2 ];

  postPatch = ''
    sed -i '/# --enable-new-dtags:/,/esac/ d' configure.ac
  '';

  meta = with lib; {
    homepage = "https://github.com/clusterlabs/libqb";
    description = "Library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
