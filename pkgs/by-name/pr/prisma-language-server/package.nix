{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "prisma-language-server";
  version = "6.18.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "language-tools";
    tag = "${finalAttrs.version}";
    hash = "sha256-o6v7IcpSXDBd/R5XmSMklc3GsWWLKAvvzmi7bTTDlpU=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/language-server";
  npmDepsHash = "sha256-XcJ5ky9MLa2Ta7Xuwf57Zs6SzpUR5h5J640TH39Ukbg=";

  meta = {
    description = "Language server for Prisma";
    homepage = "https://github.com/prisma/language-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mmkaram ];
    mainProgram = "prisma-language-server";
  };
})
