{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  nh-unwrapped,
  nix-output-monitor,
}:
let
  unwrapped = nh-unwrapped;
  runtimeDeps = [
    nix-output-monitor
  ];
in
symlinkJoin {
  pname = "nh";
<<<<<<< HEAD
  inherit (unwrapped) version;
=======
  inherit (unwrapped) version meta;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  paths = [
    unwrapped
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postBuild = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';
<<<<<<< HEAD

  meta = {
    inherit (unwrapped.meta)
      changelog
      description
      homepage
      license
      mainProgram
      maintainers
      ;

    # To prevent builds on hydra
    hydraPlatforms = [ ];
    # prefer wrapper over the package
    priority = (unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
  };
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
