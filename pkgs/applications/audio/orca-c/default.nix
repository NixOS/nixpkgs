{ stdenv, fetchFromGitHub, ncurses, portmidi }:
stdenv.mkDerivation {
  pname = "orca-c";

  version = "git-2020-05-01";

  src = fetchFromGitHub {
    owner = "hundredrabbits";
    repo = "Orca-c";
    rev = "d7a3b169c5ed0b06a9ad0fdb3057704da9a0b6ce";
    sha256 = "101y617a295hzwr98ykvza1sycxlk29kzxn2ybjwc718r0alkbzz";
  };

  buildInputs = [ ncurses portmidi ];

  patchPhase = ''
    patchShebangs tool
  '';

  installPhase = ''
    mkdir -p $out/bin
    install build/orca $out/bin/orca
  '';

  meta = with stdenv.lib; {
    description = "An esoteric programming language designed to quickly create procedural sequencers.";
    homepage = "https://github.com/hundredrabbits/Orca-c";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
