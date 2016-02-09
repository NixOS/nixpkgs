{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gitflow";
  version = "1.9.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "petervanderdoes";
    repo = pname;
    rev = version;
    sha256 = "0ad2421r3iq4xrdy46f4rrqbm8r3xphqcsdj3gqy8fnlrmxw5dfw";
  };

  preBuild = ''
    makeFlagsArray+=(prefix="$out")
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/petervanderdoes/gitflow;
    description = "Extend git with the Gitflow branching model";
    longDescription = ''
      A set of scripts that provide high-level repository operations
      for managing feature/release/hotfix branches in a Git repository,
      particularly suited to be utilised to follow Vincent Driessen's
      branching model.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ offline jgeerds ];
  };
}
