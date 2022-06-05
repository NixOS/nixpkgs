{ lib, buildGoModule, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
}:

with lib;

buildGoModule rec {
  pname = "gogs";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "gogs";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "sha256-nAMnsRYYS5bZhLDzPdC4sj3rv1kPjckFnLoORY1HqW8=";
  };

  vendorSha256 = "sha256-U8rzYSLD9XeO5ai3p3OG74kPRI2IAlvOeZhU1Pa1BAI=";

  subPackages = [ "." ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ makeWrapper openssh ];

  buildInputs = optional pamSupport pam;

  tags =
    (  optional sqliteSupport "sqlite"
    ++ optional pamSupport "pam");

  postInstall = ''

    wrapProgram $out/bin/gogs \
      --prefix PATH : ${makeBinPath [ bash git gzip openssh ]}
  '';

  meta = {
    description = "A painless self-hosted Git service";
    homepage = "https://gogs.io";
    license = licenses.mit;
    maintainers = [ maintainers.schneefux ];
  };
}
