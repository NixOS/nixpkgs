{
  lib,
  stdenv,
  fetchFromGitHub,
  cctools,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "gpac";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "gpac";
    repo = "gpac";
    rev = "v${version}";
    hash = "sha256-RADDqc5RxNV2EfRTzJP/yz66p0riyn81zvwU3r9xncM=";
  };

  # this is the bare minimum configuration, as I'm only interested in MP4Box
  # For most other functionality, this should probably be extended
  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  buildInputs = [
    zlib
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Open Source multimedia framework for research and academic purposes";
    longDescription = ''
      GPAC is an Open Source multimedia framework for research and academic purposes.
      The project covers different aspects of multimedia, with a focus on presentation
      technologies (graphics, animation and interactivity) and on multimedia packaging
      formats such as MP4.

      GPAC provides three sets of tools based on a core library called libgpac:

      A multimedia player, called Osmo4 / MP4Client,
      A multimedia packager, called MP4Box,
      And some server tools included in MP4Box and MP42TS applications.
    '';
    homepage = "https://gpac.wp.imt.fr";
    license = licenses.lgpl21;
    maintainers = with maintainers; [
      mgdelacroix
    ];
    platforms = platforms.unix;
  };
}
