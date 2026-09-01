{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jd-diff-patch";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "josephburnett";
    repo = "jd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WH6fweuntzIjoc7HodflPxEPsrJ/9t77d0z22CHjBVA=";
  };

  sourceRoot = "${finalAttrs.src.name}/v2";

  # not including web ui
  excludedPackages = [
    "gae"
    "pack"
  ];

  vendorHash = "sha256-qo5yG7DqScC4/bU7vWEKLqTZ/j+QMTg2vpl3WHjxLUI=";

  meta = {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      juliusfreudenberger
    ];
    mainProgram = "jd";
  };
})
