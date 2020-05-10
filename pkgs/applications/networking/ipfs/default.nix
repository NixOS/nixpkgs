{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.5.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "11l55hlbixv1i25d3n216pkrwgcgac99fa88lyy3dailvminqxw7";
  };

  postPatch = ''
    rm -rf test/dependencies
    patchShebangs plugin/loader/preload.sh
  '';

  buildPhase = ''
    make install
  '';

  passthru.tests.ipfs = nixosTests.ipfs;

  modSha256 = "13mpva3r6r2amw08g0bdggbxn933jjimngkvzgq1q5dksp4mivfk";

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
