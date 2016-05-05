{ stdenv, fetchFromGitHub, wxGTK30, boost, firebird }:

stdenv.mkDerivation rec {
  version = "0.9.3.1";
  name = "flamerobin-${version}";

  src = fetchFromGitHub {
    owner = "mariuz";
    repo = "flamerobin";
    rev = version;
    sha256 = "1wwcsca01hpgi9z5flvbdhs9zv7jvahnbn97j6ymy0hdyb8lv6si";
  };

  enableParallelBuilding = true;

  buildInputs = [ wxGTK30 boost firebird ];

  preBuild = ''
    sed -i 's/CXXFLAGS = -g -O2/CXXFLAGS = -g -O2 -nostartfiles/' Makefile
  '';

  configureFlags = [
    "--disable-debug"
  ];

  meta = with stdenv.lib; {
    description = "Database administration tool for Firebird RDBMS";
    homepage = "https://github.com/mariuz/flamerobin";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ uralbash ];
    platforms = platforms.unix;
  };
}
