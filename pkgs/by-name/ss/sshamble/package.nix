{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "sshamble";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "runZeroInc";
    repo = "sshamble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3MZvCZD4WzyHuGhjoA/fOYJC3LDyjFaUyB7ZeLjqLeE=";
  };

  vendorHash = "sha256-ZQzObWXljkSsjAOnveT6YY+Lzc9oK/JxiFLRKkXHQBc=";

  # Disabled because tests rely on network requests
  disabledTests = [
    "TestCacheBasics"
  ];
  checkFlags = [
    "-skip=${lib.concatStringsSep "|" finalAttrs.disabledTests}"
  ];

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "SSH-protocol pentesting utility";
    homepage = "https://github.com/runZeroInc/sshamble";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.YoshiRulz ];
    mainProgram = "sshamble";
  };
})
