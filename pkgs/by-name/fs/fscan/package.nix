{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fscan";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-05z5DuW25/hVoTdUtGGuaCBPtO1QyGqgvKWSpO8DBpQ=";
  };

  vendorHash = "sha256-IlGHY0KbYsy/5Yz11XhkcS9yS8byY3vhPZiTwnJM6/Q=";

  subPackages = [ "." ];

  meta = {
    description = "Intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
})
