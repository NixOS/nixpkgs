{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  callPackage,
  nix-update-script
}:
let
  npmHooks = callPackage ./hooks.nix { };
  nodejs = nodejs_20;
in
(buildNpmPackage.override { inherit nodejs; }) rec {
  pname = "scrypted";
  version = "0.127.1";

  src = fetchFromGitHub {
    owner = "koush";
    repo = "scrypted";
    tag = "v${version}";
    hash = "sha256-I/EFvv2JClX96mTZsYx/1lYI+N0CzmJSKrgN42VtYqU=";
  };

  npmDepsHash = "sha256-M6go8LEIB2W6/Alqj1LAQVj99eNbeuXBCYlueL5xcLk=";

  # A custom npm hook is required to skip the npm rebuild phase
  npmConfigHook = npmHooks.customConfigHook;

  sourceRoot = "${src.name}/server";

  nativeBuildInputs = [
    nodejs
  ];

  makeWrapperArgs = [ "--set NODE_ENV production" ];

  postInstall = ''
    cp ${
      lib.escapeShellArg (builtins.toFile "install.json" (builtins.toJSON { inherit version; }))
    } $out/install.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = ''
      Scrypted is a high performance home video integration platform and NVR with smart detections.
    '';
    mainProgram = "scrypted-serve";
    homepage = "https://github.com/koush/scrypted";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    # maintainers = lib.maintainers [ ];
  };
}
