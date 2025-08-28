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
  version = "v2.2.1";

  src = fetchFromGitHub {
    owner = "CJ-Systems";
    repo = "gitflow-cjs";
    rev = version;
    sha256 = "sha256-uc4WVbvr6BpHnuznLPgVJQL7eaidp0IoOcuj+QqgAkQ=";
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
    homepage = "https://github.com/CJ-Systems/gitflow-cjs";
    description = "Extend git with the Gitflow branching model";
    mainProgram = "git-flow";
    longDescription = ''
      A set of scripts that provide high-level repository operations
      for managing feature/release/hotfix branches in a Git repository,
      particularly suited to be utilised to follow Vincent Driessen's
      branching model.
    '';
    license = licenses.lgpl21Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ offline ];
  };
}
