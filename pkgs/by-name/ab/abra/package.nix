{
  lib,
  buildGoModule,
  fetchFromGitea,
  writeScript,
}:

buildGoModule (finalAttrs: {
  pname = "abra";
  version = "0.11.0-beta";

  src = fetchFromGitea {
    domain = "git.coopcloud.tech";
    owner = "toolshed";
    repo = "abra";
    rev = finalAttrs.version;
    hash = "sha256-m0x5uC6E5p3Yj/oFw37s1e0biaF8Qh3hP4d9jew8mlA=";
  };

  vendorHash = null;

  subPackages = [ "cmd/abra" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = writeScript "update-abra" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq nix-update

    set -euo pipefail

    # Get latest release from Gitea API, sorted by published date
    latest_version=$(curl -s "https://git.coopcloud.tech/api/v1/repos/toolshed/abra/releases" | \
      jq -r 'sort_by(.published_at) | reverse | .[0].tag_name')

    if [ -z "$latest_version" ] || [ "$latest_version" = "null" ]; then
      echo "Could not find latest release"
      exit 1
    fi

    echo "Latest version by release date: $latest_version"

    nix-update --version="$latest_version" abra
  '';

  meta = {
    description = "The Co-op Cloud utility belt - command-line tool for Co-op Cloud";
    mainProgram = "abra";
    homepage = "https://docs.coopcloud.tech/abra";
    changelog = "https://git.coopcloud.tech/toolshed/abra/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kolaente ];
  };
})
