{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "kakoune-unwrapped";
  version = "2023.08.05";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "v${version}";
    sha256 = "sha256-RR3kw39vEjsg+6cIY6cK2i3ecGHlr1yzuBKaDtGlOGo=";
  };
  patches = [
    # Use explicit target types for gather calls to bypass clang regression
    #
    # Since clang-16 there has been a regression in the P0522R0 support.
    # (Bug report at https://github.com/llvm/llvm-project/issue/63281)
    #
    # Closes mawww/kakoune#4892
    (fetchpatch {
      url = "https://github.com/mawww/kakoune/commit/7577fa1b668ea81eb9b7b9af690a4161187129dd.patch";
      hash = "sha256-M0jKaEDhkpvX+n7k8Jf2lWaRNy8bqZ1kRHR4eG4npss=";
    })
  ];
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
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.unix;
  };
}
