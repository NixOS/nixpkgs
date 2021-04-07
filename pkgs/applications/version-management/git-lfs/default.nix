{ lib, buildGoPackage, fetchFromGitHub, ronn, installShellFiles }:

buildGoPackage rec {
  pname = "git-lfs";
  version = "2.13.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "sha256-T4s/xnu5nL6dkEIo7xGywaE+EPH2OnzsaCF9OCGu7WQ=";
  };

  goPackagePath = "github.com/git-lfs/git-lfs";

  nativeBuildInputs = [ ronn installShellFiles ];

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/config.Vendor=${version} -X ${goPackagePath}/config.GitCommit=${src.rev}" ];

  subPackages = [ "." ];

  postBuild = ''
    make -C go/src/${goPackagePath} man
  '';

  postInstall = ''
    installManPage go/src/${goPackagePath}/man/*.{1,5}
  '';

  meta = with lib; {
    description = "Git extension for versioning large files";
    homepage    = "https://git-lfs.github.com/";
    changelog   = "https://github.com/git-lfs/git-lfs/blob/v${version}/CHANGELOG.md";
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey maintainers.marsam ];
  };
}
