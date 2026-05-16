# Script to copy all derivations from a podman `image`
# to the nix store in volume `podman-volume`.
{
  writeShellApplication,
  podman,
  coreutils,
  imageDrv,
  image ? "local/nix-daemon",
  podman-volume ? "nix-daemon-store",
}:
writeShellApplication {
  name = "gitlab-runner-copy-to-nix-store";

  runtimeInputs = [
    podman
    coreutils
  ];

  text = # bash
    ''
      set -e
      set -u

      if ! podman volume inspect "${podman-volume}"; then
        echo "No '${podman-volume}' volume found -> Skip copy derivation to it"
        exit 0
      fi

      if ! podman image inspect "${image}"; then
        echo "Image not know, load it."
        podman load -i "${imageDrv}"
      fi

      CMD=$(
          cat <<"EOF"
      # Get all store paths.
      readarray -t DRVS < <(nix-store --gc --print-roots | cut -d ' ' -f 3)

      nix --extra-experimental-features nix-command copy --no-check-sigs --to /nix-custom "''${DRVS[@]}"
      EOF
      )

      echo "Podman images:"
      podman images

      echo "Copy pkgs to '${podman-volume}' from '${image}'."
      podman run --rm \
          -v "${podman-volume}:/nix-custom/nix/store" \
          "${image}" \
          bash -c "$CMD"

      echo "Successfully copied packages to '${podman-volume}'."
    '';
}
