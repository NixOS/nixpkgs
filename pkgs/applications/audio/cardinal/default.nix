{ stdenv
, fetchurl
, cmake
, dbus
, fftwFloat
, file
, freetype
, jansson
, lib
, libGL
, libX11
, libXcursor
, libXext
, libXrandr
, libarchive
, libjack2
, liblo
, libsamplerate
, libsndfile
, makeWrapper
, pkg-config
, python3
, speexdsp
, libglvnd
}:

stdenv.mkDerivation rec {
  pname = "cardinal";
  version = "24.05";

  src = fetchurl {
    url = "https://github.com/DISTRHO/Cardinal/releases/download/${version}/cardinal+deps-${version}.tar.xz";
    hash = "sha256-ZUJI5utUtST+idlL7WKBIs850EpK98cnmO47g8/iZcI=";
  };

  prePatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    file
    pkg-config
    makeWrapper
    python3
  ];

  buildInputs = [
    dbus
    fftwFloat
    freetype
    jansson
    libGL
    libX11
    libXcursor
    libXext
    libXrandr
    libarchive
    liblo
    libsamplerate
    libsndfile
    speexdsp
    libglvnd
  ];

  hardeningDisable = [ "format" ];
  makeFlags = [ "SYSDEPS=true" "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/Cardinal \
    --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}

    wrapProgram $out/bin/CardinalMini \
    --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}

    # this doesn't work and is mainly just a test tool for the developers anyway.
    rm -f $out/bin/CardinalNative
  '';

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ magnetophon PowerUser64 ];
    mainProgram = "Cardinal";
    platforms = lib.platforms.all;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
