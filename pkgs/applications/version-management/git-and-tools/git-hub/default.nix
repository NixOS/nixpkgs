{ stdenv, fetchFromGitHub, gitMinimal, python2Packages }:

stdenv.mkDerivation rec {
  name = "git-hub-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    sha256 = "1lizjyi8vac1p1anbnh6qrr176rwxp5yjc1787asw437sackkwza";
    rev = "v${version}";
    repo = "git-hub";
    owner = "sociomantic-tsunami";
  };

  buildInputs = [ python2Packages.python ];
  nativeBuildInputs = [
    gitMinimal        # Used during build to generate Bash completion.
    python2Packages.docutils
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  installFlags = [ "prefix=$(out)" "sysconfdir=$(out)/etc" ];

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
    platforms = platforms.all;
  };
}
