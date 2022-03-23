{ lib, buildGoModule, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh, pam
, sqliteSupport ? true
, pamSupport ? true
}:

with lib;

buildGoModule rec {
  pname = "gogs";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "gogs";
    repo = "gogs";
    rev = "v${version}";
    sha256 = "sha256-I3kFRKgVMGMKgHU5VEeNai8FseN/ea6MzEP94AR2Zfo=";
  };

  vendorSha256 = "sha256-3dT5D+oDd0mpJp/cP53TQcRUkmqh6g3sRBWWAUqhaAo=";

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
