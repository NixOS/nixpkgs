{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gowrap";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hexdigest";
    repo = "gowrap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aeyrz8gF6IAr9DZvB2ei7NKPJiIgCK/t+Hf/hkpIU6g=";
  };

  vendorHash = "sha256-J3aqbOrfaJth0kCm1lucYdwLZh2lNuGG9D+hPzqYq10=";

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
