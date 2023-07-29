{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kakoune-unwrapped";
  version = "2023.07.29";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "v${version}";
    sha256 = "sha256-v+TX1fGzhBJvym3lLr8K9pWwwMlf1Lt6EiT1Xl3pRPI=";
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
    broken = stdenv.cc.isClang; # https://github.com/mawww/kakoune/issues/4944
  };
}
