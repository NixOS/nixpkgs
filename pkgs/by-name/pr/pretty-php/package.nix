{
  lib,
  php,
  fetchFromGitHub,
  testers,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "pretty-php";
  version = "0.4.92";

  src = fetchFromGitHub {
    owner = "lkrms";
    repo = "pretty-php";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rKL6ViBEJf+GGxWood0DXVF8U7wuz22Z26SEdgDAJww=";
  };

  vendorHash = "sha256-V1oqMnDJgWujQXJJqyc2cvEvBbFv+KdXjXfb+sxs8/8=";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$TMPDIR pretty-php --version";
    };
  };

  meta = {
    description = "The opinionated PHP code formatter";
    homepage = "https://github.com/lkrms/pretty-php";
    license = lib.licenses.mit;
    mainProgram = "pretty-php";
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
  };
})
