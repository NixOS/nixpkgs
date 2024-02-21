 { lib
 , stdenv
 , fetchFromGitLab
 , libsForQt5
 , autoreconfHook
 , libtool
 , zlib
 , openssl
 , freetype
 , fontconfig
 , gcc
 , makeWrapper
 , pkg-config
 , expat
 , cmake
 }:

stdenv.mkDerivation rec {
  pname = "ophcrack";
  version = "3.8.0-3";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "pkg-security-team";
    repo = "ophcrack";
    rev = "debian/${version}";
    hash = "sha256-94zEr7aBeqMjy5Ma50W3qv1S5yx090bYuTieoZaXFcc=";
  };
  
  nativeBuildInputs = [ autoreconfHook libtool libsForQt5.wrapQtAppsHook ];
  buildInputs = [ pkg-config zlib openssl freetype fontconfig libsForQt5.qtcharts gcc expat ]; 
  dontWrapQtApps = true;
  configureFlags = [ "CFLAGS=-I/usr/include/libxml2/libxml, --enable-gui" ];

  buildPhase = ''
    make
  '';

  postBuild = ''
    wrapQtApp "$out/bin/ophcrack" 
    qtWrapperArgs = [ "--prefix PATH : $/out/bin/ophcrack"]
  '';

  meta = with lib; {
    description = "Password cracker based on the faster time-memory trade-off. With MySQL and Cisco PIX Algorithm patches";
    homepage = "https://ophcrack.sourceforge.io";
    changelog = "https://salsa.debian.org/pkg-security-team/ophcrack/-/blob/${src.rev}/ChangeLog";
    license = with licenses; [ openssl gpl2Only ];
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "ophcrack";
    platforms = platforms.all;
  };
}
