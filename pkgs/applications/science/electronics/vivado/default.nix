{ stdenv
, lib
, coreutils
, fetchurl
, patchelf
, procps
, makeWrapper
, requireFile
, ncurses5
, zlib
, libuuid
, libSM
, libICE
, libX11
, libXrender
, libxcb
, libXext
, libXtst
, libXi
, glib
, freetype
, gtk2
}:

stdenv.mkDerivation rec {
  pname = "vivado";
  version = "2017.2";

  buildInputs = [
    patchelf
    procps
    ncurses5
    makeWrapper
    coreutils
  ];

  builder = ./builder.sh;
  inherit ncurses5;

  # requireFile prevents rehashing each time, which saves time during
  # rebuilds.
  src = requireFile rec {
    name = "Xilinx_Vivado_SDK_2017.2_0616_1.tar.gz";
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Login to Xilinx, download from
      https://www.xilinx.com/support/download.html,
      rename the file to ${name}, and add it to the nix store with
      "nix-prefetch-url file:///path/to/${name}".
    '';
    sha256 = "06pb4wjz76wlwhhzky9vkyi4aq6775k63c2kw3j9prqdipxqzf9j";
  };

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    ncurses5
    zlib
    libuuid
    libSM
    libICE
    libX11
    libXrender
    libxcb
    libXext
    libXtst
    libXi
    glib
    freetype
    gtk2
  ];

  meta = with lib; {
    description = "Xilinx Vivado";
    homepage = "https://www.xilinx.com/products/design-tools/vivado.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
