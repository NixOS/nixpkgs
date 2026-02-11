{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sus-compiler";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "pc2";
    repo = "sus-compiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O4aBVN7jbPm7iqMpxCRYWJ+89zcMCZTKyhRLBcQDKa8=";
    fetchSubmodules = true;
    leaveDotGit = true;

    # Manual patch phase with replacement of Git details just before they're deleted.
    # Also ensures reproducibility by removing build time.
    postFetch = ''
      cp ${./build.rs.patch} build.rs.patch
      PATCH="$(realpath build.rs.patch)"

      cd "$out"

      GIT_HASH="$(git rev-parse HEAD)"
      GIT_DATE="$(git log --pretty=format:'%ad' --date=iso-strict HEAD -1)"

      substituteInPlace "$PATCH" \
        --replace-fail "@GIT_HASH@" "$GIT_HASH" \
        --replace-fail "@GIT_DATE@" "$GIT_DATE"
      patch -p1 < "$PATCH"

      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  # no lockfile upstream
  cargoLock.lockFile = ./Cargo.lock;

  preBuild = ''
    export INSTALL_SUS_HOME="$out/share/sus-compiler";
    mkdir -p "$INSTALL_SUS_HOME"
  '';

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # Do the install version check only on stable versions of this compiler, when the build platform
  # is able to execute the binaries. Unstable versions report a "-devel" string instead of agreeing
  # with the nixpkgs version scheme.
  doInstallCheck =
    let
      isStable = !lib.elem "unstable" (lib.versions.splitVersion finalAttrs.version);
      canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    in
    isStable && canExecute;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/sus_compiler";

  updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "New Hardware Design Language that keeps you in the driver's seat";
    homepage = "https://github.com/pc2/sus-compiler";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "sus_compiler";
  };
})
