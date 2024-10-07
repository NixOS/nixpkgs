{ lib
, fetchFromGitHub
, rustPlatform
, libX11
, libXinerama
}:

let
  rpathLibs = [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = "refs/tags/${version}";
    hash = "sha256-wn5DurPWFwSUtc5naEL4lBSQpKWTJkugpN9mKx+Ed2Y=";
  };

  cargoPatches = [
    # This pacth can be removed with the next version bump, it just updates the `time` crate
    ./update-time-crate.patch
  ];

  # To show the "correct" git-hash in `leftwm-check` we manually set the GIT_HASH env variable
  # can be remove together with the above patch
  GIT_HASH = "36609e0 patched";

  cargoHash = "sha256-SNq76pTAPSUGVRp/+fwCjSMP/lKVzh6wU+WZW5n/yjg=";

  buildInputs = rpathLibs;

  postInstall = ''
    for p in $out/bin/left*; do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $p
    done

    install -D -m 0555 leftwm/doc/leftwm.1 $out/share/man/man1/leftwm.1
  '';

  dontPatchELF = true;

  meta = {
    description = "Tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vuimuich yanganto ];
    changelog = "https://github.com/leftwm/leftwm/blob/${version}/CHANGELOG.md";
    mainProgram = "leftwm";
  };
}
