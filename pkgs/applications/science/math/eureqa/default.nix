{ stdenv
, patchelf
, fetchurl
, fontconfig
, freetype
, gcc
, glib
, libX11, libXext, libSM, libICE, libXrender
}:

let
  config = {
    "i686-linux" = { type = "X11_i386"; hash = "07v59c3jaapb81fzbbmf5liqc3f3g5szr2xlj91nh75sbp8kl2v9"; };
    "x86_64-linux" = { type = "X11_x86-64"; hash = "1jc9ir2y46zcyh2fr5ikwqccxnsxivdvwmfmxry6r2s1dvg50xds"; };
  }.${stdenv.system};
in
stdenv.mkDerivation rec {
  version = "1_22_0";

  name = "eureqa-${version}";

  src = fetchurl {
    url = "http://download.nutonian.com/${version}/eureqa_${version}_${config.type}.tar.gz";
    sha256 = config.hash;
  };

  buildInputs = [
    glib
    gcc.libc
    fontconfig
    freetype
    libX11
    libXext
    libSM
    libICE
    libXrender
    patchelf
  ];

  ldpath = stdenv.lib.makeLibraryPath buildInputs
    + stdenv.lib.optionalString (stdenv.system == "x86_64-linux")
      (":" + stdenv.lib.makeSearchPath "lib64" buildInputs);

  phases = "unpackPhase installPhase fixupPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp * $out
    ln -s $out/eureqa $out/bin/eureqa
  '';

  preFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${ldpath}" $out/eureqa
    patchelf --shrink-rpath $out/eureqa
  '';

  # all binaries are already stripped
  dontStrip = true;

  # we did this in prefixup already
  dontPatchELF = true;

  meta = {
    description = "Mathematical software to automatically discover analytical models via sophisticated evolutionary algorithms";
    homepage = "http://www.nutonian.com/products/eureqa/";
    license = stdenv.lib.licenses.unfree;
  };
}
