{
  stdenv
, fetchFromGitHub
, fetchurl
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
  pname = "cardinal";
  version = "22.11";

  src = fetchurl {
    url =
      "https://github.com/DISTRHO/Cardinal/releases/download/${version}/cardinal+deps-${version}.tar.xz";
    sha256 = "sha256-xYQi209whY5/lN+6Fp7PTp7JSzL6RS6VL+Exst7RrS0=";
  };

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

  hardeningDisable = [ "format" ];
  makeFlags = [ "SYSDEPS=true" "PREFIX=$(out)" ];

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
