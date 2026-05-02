{
  lib,
  stdenv,
  fetchFromGitHub,
  writeScript,
  writeShellScriptBin,
  cmake,
  SDL2,
  dxvk_2,
}:

let
  fakeGit = writeShellScriptBin "git" ''
    if [[ "$1" = "rev-parse" ]]; then
      echo $out
    elif [[ "$1" = "rev-list" ]]; then
      cat $src/.gitrev
    else
      echo "fakeGit: unexpected git command: $@" >&2
      exit 1
    fi
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mojoshader";
  version = "0-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "mojoshader";
    rev = "6333f74dbd5644789a63e903816441b16c1e8b60";
    postCheckout = "git -C $out rev-parse HEAD > $out/.gitrev";
    hash = "sha256-32gRoYFGzQksOccpM9qvhd4Q6PyyH3EpQ2rcOI7qfp4=";
  };

  buildInputs = [ SDL2 ];

  nativeBuildInputs = [
    cmake
    fakeGit # https://github.com/icculus/mojoshader/blob/abdc80360c1d4560ab8f356035dcd53ae6e9b87f/CMakeLists.txt#L41-L68
  ];

  env = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
    NIX_CFLAGS_COMPILE = "-I${dxvk_2}/include/dxvk";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "FLIP_VIEWPORT" true)
    (lib.cmakeBool "DEPTH_CLIPPING" true)
    (lib.cmakeBool "XNA4_VERTEXTEXTURE" true)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    install -Dm644 libmojoshader.* -t $out/lib

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts

    set -euo pipefail

    response=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com/repos/${finalAttrs.src.owner}/${finalAttrs.src.repo}/commits?per_page=1")
    rev=$(echo "$response" | jq -r '.[0].sha')
    date=$(echo "$response" | jq -r '.[0].commit.committer.date' | cut -c1-10)
    update-source-version mojoshader 0-unstable-$date --rev=$rev
  '';

  meta = {
    description = "Library to work with Direct3D shaders on alternate 3D APIs and non-Windows platforms";
    homepage = "https://icculus.org/mojoshader";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
  };
})
