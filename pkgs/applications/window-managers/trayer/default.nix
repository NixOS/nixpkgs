{ lib, stdenv, fetchFromGitHub, pkg-config, gdk-pixbuf, gtk2 }:

stdenv.mkDerivation rec {
  pname = "trayer";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "sargon";
    repo = "trayer-srg";
    rev = "${pname}-${version}";
    sha256 = "1mvhwaqa9bng9wh3jg3b7y8gl7nprbydmhg963xg0r076jyzv0cg";
  };

  postPatch = ''
    patchShebangs configure
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gdk-pixbuf gtk2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/sargon/trayer-srg";
    license = licenses.mit;
    description = "A lightweight GTK2-based systray for UNIX desktop";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "trayer";
  };
}

