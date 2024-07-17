{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "glowing-bear";
  version = "0.9.0";

  src = fetchFromGitHub {
    rev = version;
    owner = "glowing-bear";
    repo = "glowing-bear";
    sha256 = "0lf0j72m6rwlgqssdxf0m9si99lah08lww7q7i08p5i5lpv6zh2s";
  };

  installPhase = ''
    mkdir $out
    cp index.html serviceworker.js webapp.manifest.json $out
    cp -R 3rdparty assets css directives js $out
  '';

  meta = with lib; {
    description = "A web client for Weechat";
    homepage = "https://github.com/glowing-bear/glowing-bear";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
