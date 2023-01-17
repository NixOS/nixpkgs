{ lib, buildGoModule, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
}:


buildGoModule rec {
  pname = "gogs";
  version = "0.12.10";

  src = fetchFromGitHub {
    owner = "gogs";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "sha256-EFGC94aIMW7AYJpgaHBT4W7BjXd+oijMqQPH40rIvlg=";
  };

  vendorSha256 = "sha256-5AnQ7zF2UK1HNoyr6gwFdVv+KMJEGkjKPpDEpUXckUg=";

  subPackages = [ "." ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ makeWrapper openssh ];

  buildInputs = lib.optional pamSupport pam;

  tags =
    (  lib.optional sqliteSupport "sqlite"
    ++ lib.optional pamSupport "pam");

  postInstall = ''

    wrapProgram $out/bin/gogs \
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  meta = with lib; {
    description = "A painless self-hosted Git service";
    homepage = "https://gogs.io";
    license = licenses.mit;
    maintainers = [ maintainers.schneefux ];
  };
}
