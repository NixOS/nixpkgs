{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "cntb";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "contabo";
    repo = "cntb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FR55cvsEEKR+zdvHrJWtmIv/fUn2nAY7JKd2DUlhb4M=";
    # docs contains two files with the same name but different cases,
    # this leads to a different hash on case insensitive filesystems (e.g. darwin)
    # https://github.com/contabo/cntb/issues/34
    postFetch = ''
      rm -rf $out/openapi/docs
    '';
  };

  subPackages = [ "." ];

  vendorHash = "sha256-uM7RaVF95WsNok3W7smfX952+Ojl2saGO41QRIFG824=";

  ldflags = [
    "-X contabo.com/cli/cntb/cmd.version=${finalAttrs.src.rev}"
    "-X contabo.com/cli/cntb/cmd.commit=${finalAttrs.src.rev}"
    "-X contabo.com/cli/cntb/cmd.date=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "CLI tool for managing your products from Contabo like VPS and VDS";
    mainProgram = "cntb";
    homepage = "https://github.com/contabo/cntb";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aciceri ];
  };
})
