{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "gf";
  version = "2.9.3";

  finalAttrs = {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "gogf";
      repo = "gf";
      tag = "cmd/gf/v${version}";
      hash = "sha256-3mOnIBmIHdqiz3lBir/gjqhNBNHU95P+j21hnedZ+Ew=";
    };

    vendorHash = "sha256-Z0TC3IyK8BDq2ZF/B/3DI9f2mxkcHtbdtS6CguM/u7c=";

    modRoot = "cmd/gf";
    subPackages = [ "." ];

    doCheck = true;

    env = {
      GOWORK = "off";
    };

    ldflags = [
      "-s"
      "-w"
    ];

    meta = {
      description = "gf is a powerful CLI tool for building GoFrame application with convenience";
      homepage = "https://goframe.org";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ cococolanosugar ];
      mainProgram = "gf";
    };
  };
in
buildGoModule finalAttrs
