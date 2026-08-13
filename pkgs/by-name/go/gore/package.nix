{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gore";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "gore";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0J+FnR2hFpoRV4+5NvU4Sp9YT+bNIXftruBDXPe9MIw=";
  };

  vendorHash = "sha256-oS5LJfLFrmHEwayoD+HygfamZpmerIL1i4QtoRL4Om4=";

  doCheck = false;

  meta = {
    description = "Yet another Go REPL that works nicely";
    mainProgram = "gore";
    homepage = "https://github.com/x-motemen/gore";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
