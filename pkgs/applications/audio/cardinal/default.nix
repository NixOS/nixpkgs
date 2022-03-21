{
  stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, fetchzip
, freetype
, jansson
, lib
, libGL
, libX11
, libXcursor
, libXext
, libXrandr
, libarchive
, liblo
, libsamplerate
, mesa
, pkg-config
, python3
, speexdsp
}:

stdenv.mkDerivation rec {
  name = "cardinal-${version}";
  version = "22.02";

  src = fetchurl {
    url =
      "https://github.com/DISTRHO/Cardinal/releases/download/${version}/cardinal-${version}.tar.xz";
    sha256 = "sha256-IVlAROFGFffTEU00NCmv74w1DRb7dNMp20FeBVoDrdM=";
  };

  patches = [
    # see https://github.com/DISTRHO/Cardinal/issues/151#issuecomment-1041886260
    (fetchpatch {
      url =
        "https://github.com/DISTRHO/Cardinal/commit/13e9ef37c5dd35d77a54b1cb006767be7a72ac69.patch";
      sha256 = "sha256-NYUYLbLeBX1WEzjPi0s/T1N+EXQKyi0ifbPxgBYDjRs=";
    })
  ];

  prePatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    freetype
    jansson
    libGL
    libX11
    libXcursor
    libXext
    libXrandr
    libXrandr
    libarchive
    liblo
    libsamplerate
    mesa
    python3
    speexdsp
  ];

  makeFlags = [ "SYSDEPS=true" "PREFIX=$(out)" ];

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
  };
}
