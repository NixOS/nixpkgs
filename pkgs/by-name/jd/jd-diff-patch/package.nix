{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jd-diff-patch";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "josephburnett";
    repo = "jd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-chCxbbRZEE29KVnTQWID889kJ2H4qJGVL+vsxzr6VtA=";
  };

  # not including web ui
  excludedPackages = [
    "gae"
    "pack"
  ];

  vendorHash = null;

  meta = {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bryanasdev000
    ];
    mainProgram = "jd";
  };
})
