{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "starspace";
  version = "unstable-2019-12-13";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "8aee0a950aa607c023e5c91cff518bec335b5df5";
    sha256 = "0sc7a37z1skb9377a1qs8ggwrkz0nmpybx7sms38xj05b702kbvj";
  };

  buildInputs = [
    boost
    zlib
  ];

  makeFlags = [
    "CXX=${stdenv.cc.targetPrefix}c++"
    "BOOST_DIR=${boost.dev}/include"
  ];

  preBuild = ''
    cp makefile_compress makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv starspace $out/bin
  '';

  meta = with lib; {
    # Does not build against gcc-13. No development activity upstream
    # for past few years.
    broken = true;
    description = "General-purpose neural model for efficient learning of entity embeddings";
    homepage = "https://ai.facebook.com/tools/starspace/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.mausch ];
  };
}
