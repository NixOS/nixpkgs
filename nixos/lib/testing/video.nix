{ config, pkgs, ... }:

{
  passthru.videos = pkgs.runCommand "vm-test-run-${config.name}-videos" {
    src = config.test;
    nativeBuildInputs = [ pkgs.qemu_test.tools ];
  } ''
    mkdir -p "$out/nix-support"
    if [ -e "$src/nix-support/hydra-build-products" ]; then
      cp "$src/nix-support/hydra-build-products" \
        > "$out/nix-support/hydra-build-products"
    fi

    for video in "$src/"*.video; do
      vidbase="$(basename "$video")"
      destfile="''${vidbase%.*}.webm"
      nixos-test-encode-video "$video" "$out/$destfile"
      echo "report video $out $destfile" \
        >> "$out/nix-support/hydra-build-products"
    done
  '';
}
