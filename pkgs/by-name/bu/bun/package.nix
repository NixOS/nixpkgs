{
  lib,
  stdenv,
  symlinkJoin,
  makeBinaryWrapper,
  bun-unwrapped,
}:

let
  unwrapped = bun-unwrapped;
in
symlinkJoin {
  pname = "bun";
  inherit (unwrapped) version; # nixpkgs-update: no auto update

  __structuredAttrs = true;
  strictDeps = true;

  paths = [ unwrapped ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ makeBinaryWrapper ];

  postBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/bun" \
      --prefix C_INCLUDE_PATH : "${lib.getDev stdenv.cc.libc}/include" \
      --prefix LIBRARY_PATH : "${lib.getLib stdenv.cc.libc}/lib"

    rm "$out/bin/bunx"
    ln -s bun "$out/bin/bunx"
  '';

  passthru = {
    inherit unwrapped;
  };

  meta = {
    inherit (unwrapped.meta)
      changelog
      description
      homepage
      license
      longDescription
      mainProgram
      maintainers
      platforms
      ;

    # The wrapper is cheap to build locally and should not be a Hydra job.
    hydraPlatforms = [ ];

    # Prefer the wrapper when both packages are installed in the same profile.
    priority = (unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
  };
}
