{ stdenv, fetchFromGitHub, pythonPackages, mopidy, mopidy-spotify }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-spotify-tunigo-${version}";

  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "trygveaa";
    repo = "mopidy-spotify-tunigo";
    rev = "v${version}";
    sha256 = "1jwk0b2iz4z09qynnhcr07w15lx6i1ra09s9lp48vslqcf2fp36x";
  };

  propagatedBuildInputs = [ mopidy mopidy-spotify pythonPackages.tunigo ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for providing the browse feature of Spotify";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
