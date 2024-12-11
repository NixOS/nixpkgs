{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cntb";
  version = "1.4.12";

  src = fetchFromGitHub {
    owner = "contabo";
    repo = "cntb";
    rev = "v${version}";
    hash = "sha256-5JOO9tWMjy81wSB9Vq/gBYZ0xfrhES0dm/cTqXP8HiI";
    # docs contains two files with the same name but different cases,
    # this leads to a different hash on case insensitive filesystems (e.g. darwin)
    # https://github.com/contabo/cntb/issues/34
    postFetch = ''
      rm -rf $out/openapi/docs
    '';
  };

  subPackages = [ "." ];

  vendorHash = "sha256-IBDVHQe6OOGQ27G7uXKRtavy4tnCvIbL07j969/E9Vg=";

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
