{
  lib,
  stdenv,
  fetchFromGitHub,
  puredata,
}:

stdenv.mkDerivation {
  pname = "cyclone";
  version = "unstable-2023-09-12";

  src = fetchFromGitHub {
    owner = "porres";
    repo = "pd-cyclone";
    rev = "7c470fb03db66057a2198843b635ac3f1abde84d";
    hash = "sha256-ixfnmeoRzV0qEOOIxCV1361t3d59fwxjHWhz9uXQ2ps=";
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
}
