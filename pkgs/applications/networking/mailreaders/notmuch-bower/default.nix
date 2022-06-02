{ lib, stdenv, fetchFromGitHub, mercury, pandoc, ncurses, gpgme }:

stdenv.mkDerivation rec {
  pname = "notmuch-bower";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "wangp";
    repo = "bower";
    rev = version;
    sha256 = "0r5s16pc3ym5nd33lv9ljv1p1gpb7yysrdni4g7w7yvjrnwk35l6";
  };

  nativeBuildInputs = [ mercury pandoc ];

  buildInputs = [ ncurses gpgme ];

  makeFlags = [ "PARALLEL=-j$(NIX_BUILD_CORES)" "bower" "man" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv bower $out/bin/
    mkdir -p $out/share/man/man1
    mv bower.1 $out/share/man/man1/
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/wangp/bower";
    description = "A curses terminal client for the Notmuch email system";
    maintainers = with maintainers; [ jgart ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
