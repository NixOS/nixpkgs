{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "sshp";
  version = "v1.1.3";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "bahamas10";
    repo = "sshp";
    rev = version;
    hash = "sha256-E7nt+t1CS51YG16371LEPtQxHTJ54Ak+r0LP0erC9Mk=";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    mkdir -p $out/bin
    cp sshp $out/bin/

    mkdir -p $out/share/man/man1
    cp man/sshp.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "Parallel SSH Executor";
    homepage = "https://github.com/bahamas10/sshp";
    license = licenses.mit;
    maintainers = with maintainers; [ linbreux ];
  };
}
