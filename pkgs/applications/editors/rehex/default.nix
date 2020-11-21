{ capstone
, fetchFromGitHub
, jansson
, lib
, stdenv
, wxGTK30
}:

stdenv.mkDerivation rec {
  pname = "rehex";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = pname;
    rev = version;
    sha256 = "1yj9a63j7534mmz8cl1ifg2wmgkxmk6z75jd8lkmc2sfrjbick32";
  };

  buildInputs = [
    capstone
    jansson
    wxGTK30
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Reverse Engineers' Hex Editor";
    longDescription = ''
      A cross-platform (Windows, Linux, Mac) hex editor for reverse
      engineering, and everything else.
    '';
    homepage = "https://github.com/solemnwarning/rehex";
    license = licenses.gpl2;
    maintainers = with maintainers; [ markus1189 ];
    platforms = platforms.all;
  };
}
