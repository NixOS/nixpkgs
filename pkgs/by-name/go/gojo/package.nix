{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gojo";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "gojo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jHSvNxTnecusIIdyNvZsPVw34QKIm9kEvBUESG37PDY=";
  };

  vendorHash = "sha256-XTrKbOXKxUjCC505ZVHbTaEvdxD4Zv0BFQhby3VwS4M=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-v";
  postInstallCheck = ''
    $out/bin/gojo --help > /dev/null
    seq 1 10 | $out/bin/gojo -a | grep '^\[1,2,3,4,5,6,7,8,9,10\]$' > /dev/null
  '';
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yet another Go implementation of jo";
    homepage = "https://github.com/itchyny/gojo";
    changelog = "https://github.com/itchyny/gojo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "gojo";
  };
})
