{
  pkgs,
  callPackage,
  fetchFromGitHub,
  lib,
  stdenv,
  nix-update,
  nixosTests,
  cni-plugins,
}:

let
  version = "7.14.1";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    hash = "sha256-Q+j41QhhibyE+a7iOgMKm2SeXhNV8ek97P014Wje9NQ=";
  };
  executable = callPackage ./executable.nix { inherit src version; };
  resource-types = callPackage ./resource-types.nix { inherit version; };
  init = callPackage ./init.nix { inherit src version; };
  updateScript = callPackage ./update-script.nix { inherit version; };
in
stdenv.mkDerivation rec {
  pname = "concourse";
  meta = {
    homepage = "https://concourse-ci.org";
    description = "A container-based automation system written in Go.";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lenianiva
      lightquantum
    ];
  };
  inherit version src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${executable}/bin/concourse $out/bin/
    ln -s ${cni-plugins}/bin/* $out/bin
    ln -s ${resource-types} $out/resource-types
  '';

  passthru = {
    inherit
      executable
      resource-types
      init
      updateScript
      ;

    tests = nixosTests.concourse;
  };

}
