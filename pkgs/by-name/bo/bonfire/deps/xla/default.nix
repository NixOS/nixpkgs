# Description: adapted from `pkgs/by-name/xl/xla/package.nix`
# to use `elixir-nx/xla`'s `//xla/extension:xla_extension` target instead.
{
  buildBazelPackage,
  fetchFromGitHub,
  gitMinimal,
  lib,
  mixNixDeps,
  patchelf,
  python3,
  stdenv,
  which,
  xla,
  xxd,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ numpy ]);
in
buildBazelPackage {
  pname = "xla";
  version = "0.10.0";

  # Warning(compatibility): it's very important to pin
  # the very same version as `elixir-nx/xla`
  # to avoid building problems.
  src = fetchFromGitHub {
    owner = "openxla";
    repo = "xla";
    # Same revision as Jax 0.9.0
    # https://github.com/elixir-nx/xla/blob/90e1eedd1e13e61f7bd1f5c4b78b0e14ea714d9b/Makefile#L13
    rev = "bb760b047bdbfeff962f0366ad5cc782c98657e0";
    hash = "sha256-PqOHg9wHrMSROVt2jmL9E1AOABH2khR/bdXnl6wJQ00=";
  };

  nativeBuildInputs = [
    gitMinimal
    patchelf
    pythonEnv
    which
    xxd
  ];

  prePatch = ''
    ln -s ${mixNixDeps.xla.src}/extension xla/extension
    cp -r ${mixNixDeps.xla.src}/extension/patches .
    bash patches/apply.sh
  '';

  inherit (xla)
    bazel
    requiredSystemFeatures
    meta
    removeLocal
    dontAddBazelOpts
    ;
  inherit (xla.deps)
    postPatch
    preConfigure
    bazelFlags
    ;

  bazelTargets = [
    "//xla/extension:xla_extension"
  ];

  # Explanation: same as `pkgs/by-name/xl/xla/package.nix`
  removeRulesCC = false;

  fetchAttrs = {
    sha256 =
      {
        # Warning(reproducibility): ofborg's hash, can't reproduce it on makemake.ngi.nixos.org
        x86_64-linux = "sha256-4OZp7k6dLyt9APNMzCAkH0t8eDXpik9A9nsXcllRgLU=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");
    inherit (xla.deps)
      preConfigure
      installPhase
      ;
  };

  buildAttrs = {
    outputs = [ "out" ];
    inherit (xla) dontAddBazelOpts buildInputs postConfigure;

    preConfigure = lib.concatStringsSep "\n" [
      # Explanation: already extracted by code prepended by `buildBazelPackage`,
      # so don't do it again in `xla.preConfigure`.
      ''
        deps=$(mktemp --suffix .tar)
        tar cvf $deps --files-from /dev/null
      ''
      xla.preConfigure
    ];

    installPhase = ''
      runHook preInstall
      tar xf bazel-bin/xla/extension/xla_extension.tar.gz
      mv xla_extension $out
      runHook postInstall
    '';
  };
}
