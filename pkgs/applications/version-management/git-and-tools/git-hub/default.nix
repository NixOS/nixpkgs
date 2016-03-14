{ stdenv, fetchFromGitHub, docutils, python }:

stdenv.mkDerivation rec {
  name = "git-hub-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    sha256 = "0c4kq4a906lr8nzway7qh0560n2ydvidh9rlffh44902rd48kp0h";
    rev = "v${version}";
    repo = "git-hub";
    owner = "sociomantic";
  };

  buildInputs = [ python ];
  nativeBuildInputs = [ docutils ];

  postPatch = ''
    substituteInPlace Makefile --replace rst2man rst2man.py
    patchShebangs .
  '';

  enableParallelBuilding = true;

  installFlags = [ "prefix=$(out)" ];

  postInstall = ''
    # Remove inert ftdetect vim plugin and a README that's a man page subset:
    rm -r $out/share/{doc,vim}
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Git command line interface to GitHub";
    longDescription = ''
      A simple command line interface to GitHub, enabling most useful GitHub
      tasks (like creating and listing pull request or issues) to be accessed
      directly through the Git command line.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
