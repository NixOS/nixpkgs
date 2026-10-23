{
  lib,
  stdenv,
  fetchFromGitHub,
  puredata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cyclone";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "porres";
    repo = "pd-cyclone";
    tag = "cyclone_${finalAttrs.version}";
    hash = "sha256-nAnokWcy3Rd1nFctAb6F3DBwryQvB39zkFRos8sB0Ao=";
  };

  buildInputs = [ puredata ];

  makeFlags = [
    "pdincludepath=${puredata}/include/pd"
    "prefix=$(out)"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  postInstall = ''
    mv "$out/lib/pd-externals/cyclone" "$out/"
    rm -rf $out/lib
  '';

  meta = {
    description = "Library of PureData classes, bringing some level of compatibility between Max/MSP and Pd environments";
    homepage = "http://puredata.info/downloads/cyclone";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [
      magnetophon
      carlthome
    ];
    platforms = lib.platforms.linux;
  };
})
