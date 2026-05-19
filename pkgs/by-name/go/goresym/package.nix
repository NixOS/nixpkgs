{
  lib,
  fetchFromGitHub,
  buildGoModule,
  unzip,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "goresym";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "goresym";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ICpgsqhF87jp5wrVmY1EhgKy/6XPBV4eXoFbDxPj8jc=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-pjkBrHhIqLmSzwi1dKS5+aJrrAAIzNATOt3LgLsMtx0=";

  nativeCheckInputs = [ unzip ];

  preCheck = ''
    cd test
    unzip weirdbins.zip
    cd ..
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go symbol recovery tool";
    mainProgram = "GoReSym";
    homepage = "https://github.com/mandiant/GoReSym";
    changelog = "https://github.com/mandiant/GoReSym/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
