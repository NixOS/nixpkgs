{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gowrap";
  version = "1.4.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hexdigest";
    repo = "gowrap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VIb1jxoLKDUXcm7SK0AlEF7+rR0Tsry0vMdU8KBp0cU=";
  };

  vendorHash = "sha256-mjz+nJNl3csr/gAw7aF6D/phESZvqR4uXyGuOCXeKlA=";

  subPackages = [ "cmd/gowrap" ];

  ldflags = [
    "-X=github.com/hexdigest/gowrap.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GoWrap is a command line tool for generating decorators for Go interfaces";
    homepage = "https://github.com/hexdigest/gowrap";
    changelog = "https://github.com/hexdigest/gowrap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "gowrap";
  };
})
