{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch2,
  makeWrapper,
  massdns,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "puredns";
  version = "2.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "d3mondev";
    repo = "puredns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3I4ZRj0bM6VfdnaG7pG9E4Qw4dpxlX4xJbsOIZu01i0=";
  };

  vendorHash = "sha256-JB0Xojjh2STXwrpZxCvTgvp80ZLtL0jhhzTsiYOWtIM=";

  overrideModAttrs = _: { patches = finalAttrs.patches; };

  patches = [
    # https://github.com/d3mondev/puredns/pull/71
    (fetchpatch2 {
      name = "bump-go.patch";
      url = "https://github.com/d3mondev/puredns/commit/4c58955c5d9450b9aecad2213c253a6eb2670c33.patch?full_index=1";
      hash = "sha256-CzlfN4ld065O7OVI5vILeyvv+jWBbAeweVgkeL80UDY=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    massdns
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [ "-s" ];

  postFixup = ''
    wrapProgram $out/bin/puredns --prefix PATH : "${lib.makeBinPath [ massdns ]}"
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Domain resolver and subdomain bruteforcing tool";
    homepage = "https://github.com/d3mondev/puredns";
    changelog = "https://github.com/d3mondev/puredns/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "puredns";
  };
})
