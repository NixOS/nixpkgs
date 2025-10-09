{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "mw";
  version = "0-unstable-2023-08-04";

  src = fetchFromGitHub {
    owner = "mark-when";
    repo = "mw";
    rev = "a8676da1c7812a051456fabcb980c52a72f6e75e";
    hash = "sha256-i95WuTH8qY+0PYQA9kOykQL+4d4oB2Hlvg9sfGtDeCo=";
  };

  npmDepsHash = "sha256-D1hTaoM4j81qrrLMoKJ7OxJTfRoht3/yqgJs95EFxY4=";

  # correctly substitute the usage message
  postPatch = ''
    substituteInPlace src/index.ts  --replace \
    '.usage("$0' '.usage("mw'
  '';

  meta = {
    changelog = "https://github.com/mark-when/mw/blob/${src.rev}/CHANGELOG.md";
    description = "Markwhen CLI";
    homepage = "https://github.com/mark-when/mw";
    license = lib.licenses.mit;
    longDescription = ''
      Markwhen is an interactive text-to-timeline tool. Write markdown-ish text and it gets converted into a nice looking cascading timeline.
    '';
    mainProgram = "mw";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
