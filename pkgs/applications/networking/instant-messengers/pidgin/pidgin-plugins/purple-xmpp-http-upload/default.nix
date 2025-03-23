{
  lib,
  stdenv,
  fetchFromGitHub,
  pidgin,
  glib,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "purple-xmpp-upload";
  version = "unstable-2021-11-04";

  src = fetchFromGitHub {
    owner = "Junker";
    repo = "purple-xmpp-http-upload";
    rev = "f370b4a2c474c6fe4098d929d8b7c18aeba87b6b";
    sha256 = "0n05jybmibn44xb660p08vrrbanfsyjn17w1xm9gwl75fxxq8cdc";
  };

  buildInputs = [
    pidgin
    glib
    libxml2
  ];

  installPhase = ''
    install -Dm644 -t $out/lib/purple-2 jabber_http_file_upload.so
  '';

  meta = with lib; {
    homepage = "https://github.com/Junker/purple-xmpp-http-upload";
    description = "HTTP File Upload plugin for libpurple (XMPP Protocol XEP-0363)";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ emmanuelrosa ];
  };
}
