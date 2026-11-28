{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "cycle";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thedenisnikulin";
    repo = "cycle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pQo2Tr/RZPjn5TcKxrk7r+NHbcAZzqza9JQhMdGrKTc=";
  };

  vendorHash = null;

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Toggle / increment / decrement whatever comes in on stdin";
    homepage = "https://github.com/thedenisnikulin/cycle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "cycle";
  };
})
