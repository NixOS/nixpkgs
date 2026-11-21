{
  caprine,
  electron,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nix-update-script,
}:

caprine.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "bankjaneo-caprine";
    version = "2.61.24";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "bankjaneo";
      repo = "caprine";
      tag = "v${finalAttrs.version}";
      hash = "sha256-7iqB+gLphQzc53tS57ubH5c0gp/rZ6S2p7QTZ9oUx5c=";
    };

    npmDepsHash = "sha256-n+GNKx1m7e7B+NHG5RSlWNzIiz98spoIqByUCj349I4=";
    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) src patches;
      name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
      hash = finalAttrs.npmDepsHash;
    };

    postBuild = ''
      electron_dist="$(mktemp -d)"
      cp -r ${electron.dist}/. "$electron_dist"
      chmod -R u+w "$electron_dist"

      npm exec electron-builder -- \
        --dir \
        -c.npmRebuild=true \
        -c.asarUnpack="**/*.node" \
        -c.electronDist="$electron_dist" \
        -c.electronVersion=${electron.version} \
        -c.mac.identity=null
    '';

    passthru = (previousAttrs.passthru or { }) // {
      updateScript = nix-update-script {
        extraArgs = [
          "--use-github-releases"
          "--version-regex"
          "^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
        ];
      };
    };

    meta = previousAttrs.meta // {
      changelog = "https://github.com/bankjaneo/caprine/releases/tag/v${finalAttrs.version}";
      description = "Fork of Caprine adapted to Facebook's current Messenger interface";
      homepage = "https://github.com/bankjaneo/caprine";
      maintainers = with lib.maintainers; [ tyceherrman ];
      mainProgram = "caprine";
    };
  }
)
