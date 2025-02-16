{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cntb";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "contabo";
    repo = "cntb";
    rev = "v${version}";
    hash = "sha256-ym4SYeAkxKBq/0VgyXx1uoHiM29LEXMqHl3XICdM30Y=";
    # docs contains two files with the same name but different cases,
    # this leads to a different hash on case insensitive filesystems (e.g. darwin)
    # https://github.com/contabo/cntb/issues/34
    postFetch = ''
      rm -rf $out/openapi/docs
    '';
  };

  subPackages = [ "." ];

  vendorHash = "sha256-6J93Nt9MhnTjsah8sDff0SvImzOEsSdnDHBhUADmO1k=";

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
