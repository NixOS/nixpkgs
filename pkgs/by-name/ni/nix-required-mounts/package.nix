{
  addDriverRunpath,
  allowedPatternsPath ? callPackage ./closure.nix { inherit allowedPatterns; },
  allowedPatterns ? {
    # This config is just an example.
    # When the hook observes either of the following requiredSystemFeatures:
    nvidia-gpu.onFeatures = [
      "gpu"
      "nvidia-gpu"
      "opengl"
      "cuda"
    ];
    # It exposes these paths in the sandbox:
    nvidia-gpu.paths = [
      addDriverRunpath.driverLink
      "/dev/dri"
      "/dev/nvidia*"
    ];
    nvidia-gpu.unsafeFollowSymlinks = true;
  },
  callPackage,
  extraWrapperArgs ? [ ],
  lib,
  makeWrapper,
  nix,
  nixosTests,
  python3Packages,
}:

let
  attrs = fromTOML (builtins.readFile ./pyproject.toml);
  pname = attrs.project.name;
  inherit (attrs.project) version;
in

python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.setuptools
  ];

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --add-flags "--patterns ${allowedPatternsPath}" \
      --add-flags "--nix-exe ${lib.getExe nix}" \
      ${builtins.concatStringsSep " " extraWrapperArgs}
  '';

  passthru = {
    inherit allowedPatterns;
    tests = {
      inherit (nixosTests) nix-required-mounts;
    };
  };
  meta = {
    inherit (attrs.project) description;
    homepage = attrs.project.urls.Homepage;
    license = lib.licenses.mit;
    mainProgram = attrs.project.name;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
