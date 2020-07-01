{ stdenv, fetchFromGitHub, imlib2, libX11 }:

stdenv.mkDerivation {
  pname = "ssocr";
  version = "unstable-2018-08-11";

  src = fetchFromGitHub {
    owner = "auerswal";
    repo = "ssocr";
    rev = "5e47e26b125a1a13bc79de93a5e87dd0b51354ca";
    sha256 = "0yzprwflky9a7zxa3zic7gvdwqg0zy49zvrqkdxng2k1ng78k3s7";
  };

  nativeBuildInputs = [ imlib2 libX11 ]; 

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Seven Segment Optical Character Recognition";
    homepage = "https://github.com/auerswal/ssocr";
    license = licenses.gpl3;
    maintainers = [ maintainers.kroell ];
  };
}
