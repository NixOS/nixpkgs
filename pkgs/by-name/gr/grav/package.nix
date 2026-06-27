{
  stdenvNoCC,
  lib,
  fetchzip,
  nixosTests,
}:

let
  version = "2.0.2";
in
stdenvNoCC.mkDerivation {
  pname = "grav";
  inherit version;

  src = fetchzip {
    url = "https://github.com/getgrav/grav/releases/download/${version}/grav-admin-v${version}.zip";
    hash = "sha256-fsTPyIpcGTcwFiKJhDSmuoaGxJyCqq8+ej6RVsmi15s=";
  };

  patches = [
    # Disables functionality that attempts to edit files in Nix store. Also adds
    # a block of the self-upgrade command.
    ./01-nix.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/
    runHook postInstall
  '';

  passthru.tests = {
    grav = nixosTests.grav;
  };

  meta = {
    description = "Fast, simple, and flexible, file-based web platform";
    homepage = "https://getgrav.com";
    maintainers = with lib.maintainers; [ rycee ];
    license = lib.licenses.mit;
  };
}
