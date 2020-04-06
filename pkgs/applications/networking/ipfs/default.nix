{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.4.23";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "19m1bhqf1jghdv2ngdnjdk1kvjcxbkgm1ccdkmkabv4ii43h8jwm";
  };

  postPatch = ''
    rm -rf test/dependencies
  '';

  modSha256 = "12m4ind1s8zaa6kssblc28z2cafy20w2jp80kzif39hg5ar9bijm";

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
