{ lib, fetchFromGitLab, git, buildGoModule }:
let
  data = lib.importJSON ../data.json;
in
buildGoModule rec {
  pname = "gitlab-workhorse";

<<<<<<< HEAD
  version = "16.3.3";
=======
  version = "15.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = data.owner;
    repo = data.repo;
    rev = data.rev;
    sha256 = data.repo_hash;
  };

<<<<<<< HEAD
  sourceRoot = "${src.name}/workhorse";

  vendorHash = "sha256-Gitap0cWRubtWLJcT8oVg9FKcN9FhXbVy/t2tgaZ93Q=";
=======
  sourceRoot = "source/workhorse";

  vendorSha256 = "sha256-/snYfip1f0TCVoPk80thanYpbYsGjEd+CAcxIt289As=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ git ];
  ldflags = [ "-X main.Version=${version}" ];
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = teams.gitlab.members;
=======
    maintainers = with maintainers; [ globin talyz yayayayaka ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
  };
}
