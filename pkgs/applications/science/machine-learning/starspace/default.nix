{ lib, stdenv, fetchFromGitHub, boost165, zlib }:

stdenv.mkDerivation rec {
  pname = "starspace";
  version = "unstable-2021-01-17";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "8aee0a950aa607c023e5c91cff518bec335b5df5";
    sha256 = "0sc7a37z1skb9377a1qs8ggwrkz0nmpybx7sms38xj05b702kbvj";
  };

  buildInputs = [ boost165 zlib ];

  makeFlags = [
    "CXX=${stdenv.cc.targetPrefix}c++"
    "BOOST_DIR=${boost165.dev}/include"
  ];

  preBuild = ''
    cp makefile_compress makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv starspace $out/bin
  '';

  meta = with lib; {
    description = "General-purpose neural model for efficient learning of entity embeddings";
    homepage = "https://ai.facebook.com/tools/starspace/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.mausch ];
  };
}
