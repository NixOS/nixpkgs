{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gore";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = "gore";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-niMYoYkDaZsv6ntUIfB0B4VheiG6rMouZGUSjHnm51w=";
  };

  vendorHash = "sha256-oS5LJfLFrmHEwayoD+HygfamZpmerIL1i4QtoRL4Om4=";

  doCheck = false;

  meta = {
    description = "Yet another Go REPL that works nicely";
    mainProgram = "gore";
    homepage = "https://github.com/motemen/gore";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
