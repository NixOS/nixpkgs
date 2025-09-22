{
  lib,
  stdenv,
  fetchurl,
  libXmu,
  libXt,
  libX11,
  libXext,
  libXxf86vm,
  libjack2,
  makeWrapper,
}:

let
  rpath = lib.makeLibraryPath [
    libXmu
    libXt
    libX11
    libXext
    libXxf86vm
    libjack2
  ];
in
stdenv.mkDerivation rec {
  pname = "baudline";
  version = "1.08";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://web.archive.org/web/20230130224632/https://www.baudline.com/baudline_${version}_linux_x86_64.tar.gz";
        hash = "sha256-RG8QPSXHo2qfOEn6eWWTh0ilg44tI1KyjXFm+SYnKKM=";
      }
    else if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "https://web.archive.org/web/20230130224632/https://www.baudline.com/baudline_${version}_linux_i686.tar.gz";
        hash = "sha256-2A13FyUl4NNWzRConw6gGjBaHxCXYlwtgxbz0ARgI28=";
      }
    else
      throw "baudline isn't supported (yet?) on ${stdenv.hostPlatform.system}";

  nativeBuildInputs = [ makeWrapper ];

  # Prebuilt binary distribution.
  # "patchelf --set-rpath" seems to break the application (cannot start), using
  # LD_LIBRARY_PATH wrapper script instead.
  dontBuild = true;
  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/libexec/baudline"

    cp -r . "$out/libexec/baudline/"

    interpreter="$(echo ${stdenv.cc.libc}/lib/ld-linux*)"
    for prog in "$out"/libexec/baudline/baudline*; do
        patchelf --interpreter "$interpreter" "$prog"
        ln -sr "$prog" "$out/bin/"
    done
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --prefix LD_LIBRARY_PATH : ${rpath}
    done
  '';

  meta = with lib; {
    description = "Scientific signal analysis application";
    longDescription = ''
      Baudline is a time-frequency browser designed for scientific
      visualization of the spectral domain.  Signal analysis is performed by
      Fourier, correlation, and raster transforms that create colorful
      spectrograms with vibrant detail.  Conduct test and measurement
      experiments with the built in function generator, or play back audio
      files with a multitude of effects and filters.  The baudline signal
      analyzer combines fast digital signal processing, versatile high speed
      displays, and continuous capture tools for hunting down and studying
      elusive signal characteristics.
    '';
    homepage = "http://www.baudline.com/";
    # See http://www.baudline.com/faq.html#licensing_terms.
    # (Do NOT (re)distribute on hydra.)
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ maintainers.bjornfor ];
  };

}
