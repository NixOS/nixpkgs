{ lib, stdenv, fetchFromGitHub, gitMinimal, docutils }:

stdenv.mkDerivation rec {
  pname = "git-hub";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "sociomantic-tsunami";
    repo = "git-hub";
    rev = "v${version}";
    sha256 = "1df9l8fpbxjgcgi72fwaqxiay5kpfihyc63f0gj67mns9n9ic1i7";
  };

  nativeBuildInputs = [
    gitMinimal        # Used during build to generate Bash completion.
    docutils
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

  meta = with lib; {
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
