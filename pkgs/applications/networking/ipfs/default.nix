{ stdenv, buildGoPackage, fetchFromGitHub, gx, gx-go }:

buildGoPackage rec {
  name = "ipfs-${version}";
  version = "0.4.4";
  rev = "d905d485192616abaea25f7e721062a9e1093ab9";

  goPackagePath = "github.com/ipfs/go-ipfs";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "06iq7fmq7p0854aqrnmd0f0jvnxy9958wvw7ibn754fdfii9l84l";
  };

  buildInputs = [ gx gx-go ];

  # Extra build step for gx dependecies
  preBuild = ''
    (cd "go/src/${goPackagePath}"; gx install)
  '';

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    license = licenses.mit;
  };
}
