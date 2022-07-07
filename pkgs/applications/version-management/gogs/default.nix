{ lib, buildGoModule, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
}:

with lib;

buildGoModule rec {
  pname = "gogs";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "gogs";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "sha256-oXIA0JY7+pfXk5RnHWCJEkU9bL+ZIc2oXQrLwa1XHMg=";
  };

  vendorSha256 = "sha256-5AnQ7zF2UK1HNoyr6gwFdVv+KMJEGkjKPpDEpUXckUg=";

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
