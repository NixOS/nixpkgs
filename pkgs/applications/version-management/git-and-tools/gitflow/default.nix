{ pkgs, stdenv, fetchFromGitHub }:

with pkgs.lib;

stdenv.mkDerivation rec {
  pname = "gitflow";
  version = "1.12.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "petervanderdoes";
    repo = pname;
    rev = version;
    sha256 = "0smwlc1wa4ndvspc9x6f4jwnzr58achysrhhip402j98d7di8hw5";
  };

  buildInputs = [ pkgs.makeWrapper ];

  preBuild = ''
    makeFlagsArray+=(prefix="$out")
  '';

  postInstall = ''
    wrapProgram $out/bin/git-flow \
      --set FLAGS_GETOPT_CMD ${pkgs.getopt}/bin/getopt \
      --suffix PATH : ${pkgs.git}/bin
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
    maintainers = with maintainers; [ offline ];
  };
}
