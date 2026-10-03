{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  notesmd-cli,
}:

buildGoModule rec {
  pname = "notesmd-cli";
  version = "v0.3.5";

  src = fetchFromGitHub {
    owner = "Yakitrak";
    repo = "notesmd-cli";
    rev = "${version}";
    hash = "sha256-uogfh0XK/kR5UrPDyMZicOkj/VuYrz4LzOkGRIfEWCI=";
  };

  vendorHash = null;
  subPackages = [ "." ];

  __structuredAttrs = true;

  passthru.tests.version = testers.testVersion { package = notesmd-cli; };

  meta = {
    description = "Interact with an Obsidian vault from the terminal";
    homepage = "https://github.com/Yakitrak/notesmd-cli";
    license = lib.licenses.mit;
    mainProgram = "notesmd-cli";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.guilvareux ];
  };
}
