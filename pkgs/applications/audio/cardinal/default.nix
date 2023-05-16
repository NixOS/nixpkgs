{
  stdenv
, fetchFromGitHub
, fetchurl
, cmake
, dbus
<<<<<<< HEAD
, fftwFloat
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "23.07";

  src = fetchurl {
    url = "https://github.com/DISTRHO/Cardinal/releases/download/${version}/cardinal+deps-${version}.tar.xz";
    hash = "sha256-Ng2E6ML9lffmdGgn9piIF3ko4uvV/uLDb3d7ytrfcLU=";
=======
  version = "22.12";

  src = fetchurl {
    url =
      "https://github.com/DISTRHO/Cardinal/releases/download/${version}/cardinal+deps-${version}.tar.xz";
    sha256 = "sha256-fyko5cWjBNNaw8qL9uyyRxW5MFXKmOsBoR5u05AWxWY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

  buildInputs = [
    dbus
    fftwFloat
=======
  buildInputs = [
    dbus
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
    wrapProgram $out/bin/CardinalMini \
    --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # this doesn't work and is mainly just a test tool for the developers anyway.
    rm -f $out/bin/CardinalNative
  '';

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
<<<<<<< HEAD
    mainProgram = "Cardinal";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = lib.platforms.all;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
