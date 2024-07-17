{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "2.2.1";
  pname = "gpac";

  src = fetchFromGitHub {
    owner = "gpac";
    repo = "gpac";
    rev = "v${version}";
    hash = "sha256-VjA1VFMsYUJ8uJqhYgjXYtqlGWSJHr16Ck3b5stuZWw=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-2837.patch";
      url = "https://github.com/gpac/gpac/commit/6f28c4cd607d83ce381f9b4a9f8101ca1e79c611.patch";
      hash = "sha256-HA6qMungIoh1fz1R3zUvV1Ahoa2pp861JRzYY/NNDQI=";
    })
    (fetchpatch {
      name = "CVE-2023-2838.patch";
      url = "https://github.com/gpac/gpac/commit/c88df2e202efad214c25b4e586f243b2038779ba.patch";
      hash = "sha256-gIISG7pz01iVoWqlho2BL27ki87i3pGkug2Z+KKn+xs=";
    })
    (fetchpatch {
      name = "CVE-2023-2839.patch";
      url = "https://github.com/gpac/gpac/commit/047f96fb39e6bf70cb9f344093f5886e51dce0ac.patch";
      hash = "sha256-i+/iFrWJ+Djc8xYtIOYvlZ98fYUdJooqUz9y/uhusL4=";
    })
    (fetchpatch {
      name = "CVE-2023-2840.patch";
      url = "https://github.com/gpac/gpac/commit/ba59206b3225f0e8e95a27eff41cb1c49ddf9a37.patch";
      hash = "sha256-mwO9Qeeufq0wa57lO+LgWGjrN3CHMYK+xr2ZBalKBQo=";
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
    maintainers = with maintainers; [
      bluescreen303
      mgdelacroix
    ];
    platforms = platforms.linux;
    knownVulnerabilities = [
      "CVE-2023-48958"
      "CVE-2023-48090"
      "CVE-2023-48039"
      "CVE-2023-48014"
      "CVE-2023-48013"
      "CVE-2023-48011"
      "CVE-2023-47465"
      "CVE-2023-47384"
      "CVE-2023-46932"
      "CVE-2023-46931"
      "CVE-2023-46930"
      "CVE-2023-46928"
      "CVE-2023-46927"
      "CVE-2023-46871"
      "CVE-2023-46001"
      "CVE-2023-42298"
      "CVE-2023-41000"
      "CVE-2023-39562"
      "CVE-2023-37767"
      "CVE-2023-37766"
      "CVE-2023-37765"
      "CVE-2023-37174"
      "CVE-2023-23143"
      "CVE-2023-5998"
      "CVE-2023-5595"
      "CVE-2023-5586"
      "CVE-2023-5520"
      "CVE-2023-5377"
      "CVE-2023-4778"
      "CVE-2023-4758"
      "CVE-2023-4756"
      "CVE-2023-4755"
      "CVE-2023-4754"
      "CVE-2023-4722"
      "CVE-2023-4721"
      "CVE-2023-4720"
      "CVE-2023-4683"
      "CVE-2023-4682"
      "CVE-2023-4681"
      "CVE-2023-4678"
      "CVE-2023-3523"
      "CVE-2023-3291"
      "CVE-2023-3013"
      "CVE-2023-3012"
      "CVE-2023-1655"
      "CVE-2023-1654"
      "CVE-2023-1452"
      "CVE-2023-1449"
      "CVE-2023-1448"
      "CVE-2023-0866"
      "CVE-2023-0841"
      "CVE-2023-0819"
      "CVE-2023-0818"
      "CVE-2023-0817"
    ];
  };
}
