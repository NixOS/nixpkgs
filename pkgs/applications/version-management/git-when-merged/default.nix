{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "git-when-merged";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mhagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Yp/GNzD+7EPlk/kzZnT1eiSNsSxpYEiZezRbUU3HfLc=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    install -D --target-directory $out/bin/ bin/git-when-merged
  '';

  meta = with lib; {
    description =
      "Helps you figure out when and why a commit was merged into a branch";
    longDescription = ''
      If you use standard Git workflows, then you create a feature
      branch for each feature that you are working on. When the feature
      is complete, you merge it into your master branch. You might even
      have sub-feature branches that are merged into a feature branch
      before the latter is merged.

      In such a workflow, the first-parent history of master consists
      mainly of merges of feature branches into the mainline. git
      when-merged can be used to ask, "When (and why) was commit C
      merged into the current branch?"
    '';
    homepage = "https://github.com/mhagger/git-when-merged";
    license = licenses.gpl2Only;
    platforms = python3.meta.platforms;
    maintainers = with maintainers; [ DamienCassou ];
    mainProgram = "git-when-merged";
  };
}
