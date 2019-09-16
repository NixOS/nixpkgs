{ stdenv, fetchFromGitHub, gitMinimal, python2Packages }:

stdenv.mkDerivation rec {
  pname = "git-hub";
  version = "1.0.3";

  src = fetchFromGitHub {
    sha256 = "03mz64lzicbxxz9b202kqs5ysf82sgb7lw967wkjdy2wbpqk8j0z";
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
