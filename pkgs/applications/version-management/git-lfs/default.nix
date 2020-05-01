{ stdenv, buildGoPackage, fetchFromGitHub, ronn, installShellFiles }:

buildGoPackage rec {
  pname = "git-lfs";
  version = "2.10.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "1y5ryk0iz5g5sqaw79ml6fr5kvjgzcah481pk5qmnb2ipb1xlng9";
  };

  goPackagePath = "github.com/git-lfs/git-lfs";

  nativeBuildInputs = [ ronn installShellFiles ];

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/config.Vendor=${version} -X ${goPackagePath}/config.GitCommit=${src.rev}" ];

  subPackages = [ "." ];

  postBuild = ''
    make -C go/src/${goPackagePath} man
  '';

  postInstall = ''
    installManPage man/*.1 man/*.5
  '';

  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = "https://git-lfs.github.com/";
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey maintainers.marsam ];
  };
}
