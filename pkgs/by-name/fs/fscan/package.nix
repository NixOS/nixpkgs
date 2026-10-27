{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fscan";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P3zgmjlBZCmeJxYy5SRPC9Bvl9O03LUJoeAFYhp8tGA=";
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
