{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "chrome-export";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "bdesham";
    repo = "chrome-export";
    rev = "v${version}";
    sha256 = "0p1914wfjggjavw7a0dh2nb7z97z3wrkwrpwxkdc2pj5w5lv405m";
  };

  buildInputs = [ python3 ];

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp export-chrome-bookmarks export-chrome-history $out/bin
    mkdir -p $out/share/man/man1
    cp man_pages/*.1 $out/share/man/man1
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    bash test/run_tests $out/bin
  '';

  meta = with lib; {
    description = "Scripts to save Google Chrome's bookmarks and history as HTML bookmarks files";
    homepage = "https://github.com/bdesham/chrome-export";
    license = [ licenses.isc ];
    maintainers = [ maintainers.bdesham ];
    platforms = python3.meta.platforms;
  };
}
