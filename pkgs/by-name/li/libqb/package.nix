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
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = "libqb";
    rev = "v${version}";
    sha256 = "sha256-ZjxC7W4U8T68mZy/OvWj/e4W9pJIj2lVDoEjxXYr/G8=";
  };

  patches = [
    # add a declaration of fdatasync, missing on darwin https://github.com/ClusterLabs/libqb/pull/496
    (fetchpatch {
      url = "https://github.com/ClusterLabs/libqb/commit/255ccb70ee19cc0c82dd13e4fd5838ca5427795f.patch";
      hash = "sha256-6x4B3FM0XSRIeAly8JtMOGOdyunTcbaDzUeBZInXR4U=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libxml2 ];

  postPatch = ''
    sed -i '/# --enable-new-dtags:/,/--enable-new-dtags is required/ d' configure.ac
  '';

  meta = with lib; {
    homepage = "https://github.com/clusterlabs/libqb";
    description = "Library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
