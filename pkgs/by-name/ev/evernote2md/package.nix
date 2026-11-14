{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "evernote2md";
  version = "0.22.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wormi4ok";
    repo = "evernote2md";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y8Nc+rqjtVR7z9kPZZ/bZUPlmPwePCW8UmGwxxKm2J0=";
  };

  vendorHash = "sha256-AbfnxH5Xy+3ZYd74qig9ado9Nn/bqPrDEW9IfsYr+Sk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Convert Evernote .enex files to Markdown";
    homepage = "https://github.com/wormi4ok/evernote2md";
    changelog = "https://github.com/wormi4ok/evernote2md/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "evernote2md";
  };
})
