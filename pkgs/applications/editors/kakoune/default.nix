{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kakoune-unwrapped";
  version = "2023.08.05";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "v${version}";
    sha256 = "sha256-RR3kw39vEjsg+6cIY6cK2i3ecGHlr1yzuBKaDtGlOGo=";
  };
  makeFlags = [ "debug=no" "PREFIX=${placeholder "out"}" ];

  preConfigure = ''
    export version="v${version}"
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kak -ui json -e "kill 0"
  '';

  postInstall = ''
    # make share/kak/autoload a directory, so we can use symlinkJoin with plugins
    cd "$out/share/kak"
    autoload_target=$(readlink autoload)
    rm autoload
    mkdir autoload
    ln -s --relative "$autoload_target" autoload
  '';

  meta = with lib; {
    homepage = "http://kakoune.org/";
    description = "A vim inspired text editor";
    license = licenses.publicDomain;
    mainProgram = "kak";
    maintainers = with maintainers; [ vrthra srapenne ];
    platforms = platforms.unix;
  };
}
