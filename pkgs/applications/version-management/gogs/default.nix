{ lib, buildGoModule, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
}:

buildGoModule rec {
  pname = "gogs";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "gogs";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "sha256-UfxE+NaqDr3XUXpvlV989Iwjq/lsAwpMTDAPkcOmma8=";
  };

  vendorHash = "sha256-ISJOEJ1DWO4nnMpDuZ36Nq528LhgekDh3XUF8adlj2w=";

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
    description = "Painless self-hosted Git service";
    homepage = "https://gogs.io";
    license = licenses.mit;
    maintainers = [ maintainers.schneefux ];
    mainProgram = "gogs";
    knownVulnerabilities = [ ''
      Gogs has known unpatched vulnerabilities and upstream maintainers appears to be unresponsive.

      More information can be found in forgejo's blogpost: https://forgejo.org/2023-11-release-v1-20-5-1/

      You might want to consider migrating to Gitea or forgejo.
    '' ];
  };
}
