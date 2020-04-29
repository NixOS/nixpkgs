{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.5.0";
  rev = "v${version}";

  buildPhase = ''
    sed -i 'd#\$(d)/preload.sh > $@#' plugin/loader/Rules.mk
    make install
  '';

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "0dbyvs49wyqj46c8hvz0fr4vpgfrdj1h8blniwzjf0jabgvw8nik";
  };

  postPatch = ''
    rm -rf test/dependencies
  '';

  modSha256 = "00xgsvpl47miy6paxl8yn6p76h6ssccackh50z0l4r5s7wcc25q8";

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
