{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "legit";
  version = "0.2.4";

  src = fetchFromGitHub {
    repo = "legit";
    owner = "icyphox";
    rev = "v${version}";
    hash = "sha256-2XeIAeneSKf8TSWOunvRJ7N+3IrmOUjS79ZubsGne9E=";
  };

  vendorHash = "sha256-4XplNx+Pyv6dn+ophBFxQ3lv3xAf1jP2DpLYX1RenvQ=";

  postInstall = ''
    mkdir -p $out/lib/legit/templates
    mkdir -p $out/lib/legit/static

    cp -r $src/templates/* $out/lib/legit/templates
    cp -r $src/static/* $out/lib/legit/static
  '';

  passthru.tests = { inherit (nixosTests) legit; };

  meta = {
    description = "Web frontend for git";
    homepage = "https://github.com/icyphox/legit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ratsclub ];
    mainProgram = "legit";
  };
}
