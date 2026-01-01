{
  lib,
  fetchFromGitHub,

  buildGoModule,

  # tests
  testers,
  checksec,
}:

buildGoModule rec {
  pname = "checksec";
<<<<<<< HEAD
  version = "3.1.0";
=======
  version = "3.0.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "slimm609";
    repo = "checksec";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-LsVK+ufSUGXWHpPk1iAFD6Lxh5hEp1WmTAy9hZMEiKk=";
  };

  vendorHash = "sha256-GzSliyKxBfATA7BaHO/4HyReEwT7dYTpRuyjADNtJuc=";
=======
    hash = "sha256-ZpDowTmnK23+ZocOY1pJMgMSn7FiQQGvMg/gSbiL1nw=";
  };

  vendorHash = "sha256-7poHsEsRATljkqtfGxzqUbqhwSjVmiao2KoMVQ8LkD4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = checksec;
      inherit version;
    };
  };

<<<<<<< HEAD
  meta = {
    description = "Tool for checking security bits on executables";
    mainProgram = "checksec";
    homepage = "https://slimm609.github.io/checksec/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      thoughtpolice
=======
  meta = with lib; {
    description = "Tool for checking security bits on executables";
    mainProgram = "checksec";
    homepage = "https://slimm609.github.io/checksec/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      thoughtpolice
      globin
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      sdht0
    ];
  };
}
