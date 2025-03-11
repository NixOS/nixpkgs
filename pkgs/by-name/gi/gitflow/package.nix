{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  getopt,
  git,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "gitflow";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "petervanderdoes";
    repo = pname;
    rev = version;
    sha256 = "sha256-kHirHG/bfsU6tKyQ0khNSTyChhzHfzib+HyA3LOtBI8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    makeFlagsArray+=(prefix="$out")
  '';

  postInstall = ''
    wrapProgram $out/bin/git-flow \
      --set FLAGS_GETOPT_CMD ${getopt}/bin/getopt \
      --suffix PATH : ${git}/bin \
      --prefix PATH : ${coreutils}/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/petervanderdoes/gitflow";
    description = "Extend git with the Gitflow branching model";
    mainProgram = "git-flow";
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
