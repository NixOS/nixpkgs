{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bashInteractive,
  gawk,
  runtimeShell,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "blesh";
  version = "0.4.0-devel3-unstable-2026-03-10";

  src = fetchFromGitHub {
    owner = "akinomyoga";
    repo = "ble.sh";
    rev = "b99cadb4520a1fdec0067fdc007b39cc905ecbad";
    fetchSubmodules = true;
    hash = "sha256-LXDow/4yv3V0Liy12bXQ1qwO5z4u0equRO9xeJaDaWo=";
  };

  nativeBuildInputs = [
    gawk
  ];

  # Fix the cache invalidation not working; see
  # https://github.com/NixOS/nixpkgs/pull/521218#issuecomment-4641313131
  postPatch = ''
    substituteInPlace ble.pp \
      --replace-fail \
        'local ver=''${BLE_VERSINFO[0]}.''${BLE_VERSINFO[1]}' \
        'local ver=$BLE_VERSION'
  '';

  # ble.sh embeds the commit id, normally read from .git, which fetchFromGitHub omits.
  makeFlags = [
    "PREFIX=$(out)"
    "BLE_GIT_COMMIT_ID=${builtins.substring 0 7 finalAttrs.src.rev}"
    "BLE_GIT_BRANCH=master"
  ];

  doCheck = true;
  # auto-detection runs `make -n check` without makeFlags, which fails without BLE_GIT_COMMIT_ID
  checkTarget = "check";
  nativeCheckInputs = [ bashInteractive ];
  preCheck = ''
    export HOME=$TMPDIR
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
    ];
    platforms = lib.platforms.unix;
  };
})
