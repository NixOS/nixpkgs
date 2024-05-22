{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
  esbuild,
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

  esbuild' = esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.14.38";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-rvMi1oC7qGidvi4zrm9KCMMntu6LJGVOGN6VmU2ivQE=";
      };
      vendorHash = "sha256-QPkBR+FscUc3jOvH7olcGUhM6OW4vxawmNJuRQxPuGs=";
    });
  };

  frontend = buildNpmPackage {
    inherit src version;
    pname = "fider-frontend";

    dontNpmBuild = true;

    nativeBuildInputs = [
      esbuild'
    ];

    npmDepsHash = "sha256-YsWRJab/dPiZxBwvE0B3cf/L8CJpdTrOD+bWU4OSX+o=";

    env = {
      PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
      ESBUILD_BINARY_PATH = lib.getExe esbuild';
    };
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
