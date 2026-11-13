{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bashInteractive,
  less,
  procps,
  gawk,
  glibcLocalesUtf8,
  runtimeShell,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "blesh";
  version = "0.4.0-devel3-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "akinomyoga";
    repo = "ble.sh";
    rev = "152942758f567e51fd17bdc7b3783d27b3c476aa";
    fetchSubmodules = true;
    hash = "sha256-JYtwux5VQwujL6e0gOXUhIAwmkhPwxOV5/Snje9+7Jo=";
  };

  nativeBuildInputs = [
    gawk
  ];

  patches = [
    # Fix the cache invalidation not working; see
    # https://github.com/NixOS/nixpkgs/pull/521218#issuecomment-4641313131
    ./fix-cache-invalidation.patch
  ];

  # ble.sh embeds the commit id, normally read from .git, which fetchFromGitHub omits.
  makeFlags = [
    "PREFIX=$(out)"
    "BLE_GIT_COMMIT_ID=${builtins.substring 0 7 finalAttrs.src.rev}"
    "BLE_GIT_BRANCH=master"
  ];

  postPatch = ''
    patchShebangs --build make_command.sh make
  '';

  doCheck = true;
  # auto-detection runs `make -n check` without makeFlags, which fails without BLE_GIT_COMMIT_ID
  checkTarget = "check";
  nativeCheckInputs = [
    bashInteractive
    # the get-pager test expects less to be in PATH
    less
    # ble.sh refuses to load without ps, so tests would not run
    procps
  ]
  # upstream tests have hard-coded LC_ALL=en_US.utf8
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ glibcLocalesUtf8 ];

  preCheck = ''
    export HOME=$TMPDIR
    export LANG=en_US.UTF-8
    # upstream skips its flaky sleep-timing tests under GitHub CI
    export CI=true GITHUB_ACTION=nix
  '';

  postInstall = ''
    cat <<EOF >"$out/share/blesh/lib/_package.sh"
    _ble_base_package_type=nix

    function ble/base/package:nix/update {
      echo "Ble.sh is installed by Nix. You can update it there." >&2
      return 1
    }
    EOF

    mkdir -p "$out/bin"
    cat <<EOF >"$out/bin/blesh-share"
    #!${runtimeShell}
    # Run this script to find the ble.sh shared folder
    # where all the shell scripts are living.
    echo "$out/share/blesh"
    EOF
    chmod +x "$out/bin/blesh-share"

    rm -rf "$out/share/blesh/cache.d" "$out/share/blesh/run"
  '';

  # tagFormat skips the "nightly"/"spike-*" tags; the newest tag is too far
  # behind HEAD for shallow deepening, so clone fully.
  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    tagFormat = "v*";
    shallowClone = false;
  };

  meta = {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "Bash Line Editor -- a full-featured line editor written in pure Bash";
    mainProgram = "blesh-share";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      aiotter
      matthiasbeyer
      recutita
    ];
    platforms = lib.platforms.unix;
  };
})
