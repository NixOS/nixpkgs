{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cntb";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "contabo";
    repo = "cntb";
    rev = "v${version}";
    hash = "sha256-4QS1fkXVcGxhZDPRLDc0xKl4jr8W4og/Qf591i3gzxk=";
    # docs contains two files with the same name but different cases,
    # this leads to a different hash on case insensitive filesystems (e.g. darwin)
    # https://github.com/contabo/cntb/issues/34
    postFetch = ''
      rm -rf $out/openapi/docs
    '';
  };

  subPackages = [ "." ];

  vendorHash = "sha256-LOGSllVQ28bXaqHXEv1Zd1vcTRZTZ5wy+gSQv1JWKMU=";

  ldflags = [
    "-X contabo.com/cli/cntb/cmd.version=${src.rev}"
    "-X contabo.com/cli/cntb/cmd.commit=${src.rev}"
    "-X contabo.com/cli/cntb/cmd.date=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    description = "CLI tool for managing your products from Contabo like VPS and VDS";
    mainProgram = "cntb";
    homepage = "https://github.com/contabo/cntb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aciceri ];
  };
}
