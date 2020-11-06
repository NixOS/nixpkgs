{ stdenv, buildGoPackage, fetchFromGitHub, ronn, installShellFiles }:

buildGoPackage rec {
  pname = "git-lfs";
  version = "2.12.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "1x8s1w8yqhj5nm20knr2gkb59rwzx220nf099lgd62cajzsdpjx5";
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

  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = "https://git-lfs.github.com/";
    changelog   = "https://github.com/git-lfs/git-lfs/releases/tag/v${version}";
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey maintainers.marsam ];
  };
}
