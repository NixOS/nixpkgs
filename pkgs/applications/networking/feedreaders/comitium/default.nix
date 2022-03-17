{ buildGoModule, scdoc, fetchurl, lib }:

buildGoModule rec {
  pname = "comitium";
  version = "1.8.1";

  src = fetchurl {
    url = "https://git.nytpu.com/${pname}/snapshot/${pname}-${version}.tar.bz2";
    sha256 = "0xvnv8wmgpyl16vignnf8mfkah6agc5j83nnz04hk7kk1ai0y5j7";
  };

  nativeBuildInputs = [ scdoc ];

  buildPhase = ''
    make COMMIT=tarball
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  doCheck = false;
  vendorSha256 = "sha256-6xtXTmSqaN2me0kyRk948ASNNtv7P5XBvtv9UWjNHoo=";

  meta = with lib; {
    description = "Gemini feed aggregator that supports Atom, RSS and Gemini feeds";
    homepage = "https://git.nytpu.com/comitium/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.linux;
  };
}
