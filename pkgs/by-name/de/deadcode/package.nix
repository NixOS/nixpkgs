{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "deadcode";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0RiinnIocPaj8Z5jtYGkbFiRf1BXyap4Z8e/sw2FBgg=";
  };

  vendorHash = "sha256-oYmM+5lNmlP2i78NsG3v4WRhAUbiwS+EFkiicI6MKXA=";

  subPackages = [ "cmd/deadcode" ];

  meta = {
    description = "Find unreachable functions in Go programs";
    homepage = "https://pkg.go.dev/golang.org/x/tools/cmd/deadcode";
    license = lib.licenses.bsd3;
    mainProgram = "deadcode";
  };
})
