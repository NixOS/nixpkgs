{ stdenv
, fetchFromGitHub
, cmake
, installShellFiles
, pandoc
, boost
, bzip2
, expat
, libosmium
, protozero
, zlib
}:

stdenv.mkDerivation rec {
  pname = "osmium-tool";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "osmium-tool";
    rev = "v${version}";
    sha256 = "13142hj8gfgj6w51a62hjzfmzic90xgrnnlnb70hpdqjy86bxv7j";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
    pandoc
  ];

  buildInputs = [
    boost
    bzip2
    expat
    libosmium
    protozero
    zlib
  ];

  doCheck = true;

  postInstall = ''
    installShellCompletion --zsh ../zsh_completion/_osmium
  '';

  meta = with stdenv.lib; {
    description = "Multipurpose command line tool for working with OpenStreetMap data based on the Osmium library";
    homepage = "https://osmcode.org/osmium-tool/";
    license = with licenses; [ gpl3 mit bsd3 ];
    maintainers = with maintainers; [ das-g ];
  };
}
