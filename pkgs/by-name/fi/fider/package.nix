{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
}:

let
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "getfider";
    repo = "fider";
    rev = "v${version}";
    hash = "sha256-kxOorXlLkBpqWrYqLz0PbWePtdmBnL6tw1eE6g7H6dM=";
  };

  server = buildGoModule {
    inherit src version;
    pname = "fider-server";

    vendorHash = "sha256-cgUBuExQ/RTcfnWlbcCja+kF3f5CLgoQJqqJg+d5ZzA=";

    ldflags = [
      "-s"
      "-w"
    ];
  };

  frontend = buildNpmPackage {
    inherit src version;
    pname = "fider-frontend";

    npmDepsHash = "sha256-YsWRJab/dPiZxBwvE0B3cf/L8CJpdTrOD+bWU4OSX+o=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fider";
  inherit version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    ls -la ${server} ${frontend}
    runHook postInstall
  '';

  meta = {
    description = "Open platform to collect and prioritize feedback";
    homepage = "https://github.com/getfider/fider";
    license = lib.licenses.agpl3Only;
    mainProgram = "fider";
    maintainers = with lib.maintainers; [ ];
  };
})
