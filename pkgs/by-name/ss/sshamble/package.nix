{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "sshamble";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "runZeroInc";
    repo = "sshamble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-304OXnCBBPyK7txmnvrkOCu4cfTSSiTpZZh6vOUSufc=";
  };

  vendorHash = "sha256-uVef5OvCYCZvVfWMh0JTYIN5cokqslvQvYoWHHxtd5g=";

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
