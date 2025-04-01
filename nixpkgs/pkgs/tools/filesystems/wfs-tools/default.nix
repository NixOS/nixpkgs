{ lib
, stdenv
, fetchurl
, makeWrapper
, fuse
, unzip
}:

stdenv.mkDerivation rec {
  pname = "wfs-tools";
  version = "1.2.3";

  src = fetchurl {
    url = "https://github.com/koolkdev/wfs-tools/releases/download/v${version}/wfs-tools-v${version}-linux-x86-64.zip";
    hash = "sha256-lISRaVl39tr7ZD2yLyFaQ/2iyr1WJsWiXsqfOSe1lBU=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  buildInputs = [ fuse ];

  unpackPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin
    chmod +x $out/bin/wfs-*
  '';

  installPhase = ''
    # Wrap binaries with proper library paths
    for binary in $out/bin/wfs-*; do
      mv "$binary" "$binary.unwrapped"
      makeWrapper "$binary.unwrapped" "$binary" \
        --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ fuse ]}" \
        --suffix PATH : "${lib.makeBinPath [ fuse ]}"
    done
  '';

  meta = with lib; {
    description = "Tools for working with Wii U WFS filesystem";
    homepage = "https://github.com/koolkdev/wfs-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ Hyphastorm ];
    platforms = platforms.linux;
  };
} 