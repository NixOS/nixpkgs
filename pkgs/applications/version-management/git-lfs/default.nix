{ stdenv, buildGoModule, fetchFromGitHub, ronn, installShellFiles }:

buildGoModule rec {
  pname = "git-lfs";
  version = "2.11.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "git-lfs";
    repo = "git-lfs";
    sha256 = "05qd96bn2cl7gn5qarbcv6scdpj28qiwdfzalamqk5jjiidpmng5";
  };


  nativeBuildInputs = [ ronn installShellFiles ];


  subPackages = [ "." ];

  postBuild = ''
  '';

  postInstall = ''
  '';

  meta = with stdenv.lib; {
    description = "Git extension for versioning large files";
    homepage    = "https://git-lfs.github.com/";
    license     = [ licenses.mit ];
    maintainers = [ maintainers.twey maintainers.marsam ];
  };
}