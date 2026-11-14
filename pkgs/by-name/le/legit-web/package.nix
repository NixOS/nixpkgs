{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "legit";
  version = "0.2.5";

  src = fetchFromGitHub {
    repo = "legit";
    owner = "icyphox";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TMwfboBeeyPSzHoI8WHrj9sirO2dc+nCb+YDdFJMKoA=";
  };

  vendorHash = "sha256-ynv0pBdVPIhTz7RvCwVWr0vUWwfw+PEjFXs9PdQMqm8=";

  postInstall = ''
    mkdir -p $out/lib/legit/templates
    mkdir -p $out/lib/legit/static

    cp -r templates/* $out/lib/legit/templates
    cp -r static/* $out/lib/legit/static
  '';

  passthru.tests = { inherit (nixosTests) legit; };

  meta = {
    description = "Web frontend for git";
    homepage = "https://github.com/icyphox/legit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ratsclub ];
    mainProgram = "legit";
  };
})
