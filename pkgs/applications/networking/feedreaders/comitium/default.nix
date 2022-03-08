{ buildGoModule, scdoc, fetchgit, lib }:

buildGoModule rec {
  pname = "comitium";
  version = "1.8.1";

  src = fetchgit {
    url = "git://git.nytpu.com/comitium";
    rev = "cf20f5877ef1fa258849f8a283dbd4080a96eb83";
    sha256 = "01k09q9376lw8v2gh32anzf44139nym2acir11h8zpcsrb8ka9n5";
  };

  nativeBuildInputs = [ scdoc ];

  vendorSha256 = "sha256-6xtXTmSqaN2me0kyRk948ASNNtv7P5XBvtv9UWjNHoo=";

  meta = with lib; {
    description = "Gemini feed aggregator that supports Atom, RSS and Gemini feeds";
    homepage = "https://git.nytpu.com/comitium/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.linux;
  };
}
