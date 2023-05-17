{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, zlib }:

stdenv.mkDerivation rec {
  version = "2.2.0";
  pname = "gpac";

  src = fetchFromGitHub {
    owner = "gpac";
    repo = "gpac";
    rev = "v${version}";
    sha256 = "sha256-m2qXTXLGgAyU9y6GEk4Hp/7Al57IPRSqImJatIcwswQ=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-0358.patch";
      url = "https://github.com/gpac/gpac/commit/9971fb125cf91cefd081a080c417b90bbe4a467b.patch";
      sha256 = "sha256-0PDQXahbJCOo1JJAC0T0N1u2mqmwAkdm87wXMJnBicM=";
    })
  ];

  # this is the bare minimum configuration, as I'm only interested in MP4Box
  # For most other functionality, this should probably be extended
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zlib ];

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
    maintainers = with maintainers; [ bluescreen303 mgdelacroix ];
    platforms = platforms.linux;
  };
}
