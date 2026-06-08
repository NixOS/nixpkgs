{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writeScript,
}:

buildGoModule (finalAttrs: {
  pname = "enry";
  version = "1.3.0";
  commitSha = "f10711437bfbb25b15506eb69dde24bb7decd222"; # matches version

  src = fetchFromGitHub {
    owner = "go-enry";
    repo = "enry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JSYOCdWZnCM4Kq3EFkS7XZ5n0ahkR+A8omI4z1S45z8=";
  };

  vendorHash = "sha256-tUDhpeXlKpo1jnNyk0U3CcXroOlv7lHVUxc1wAnysG4=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.commitSha}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = writeScript "update-enry" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq nix-prefetch-github gnused

    set -eu -o pipefail

    latest_tag="$(curl -sS https://api.github.com/repos/go-enry/enry/releases/latest | jq -r '.tag_name')"
    prefetch_output="$(nix-prefetch-github --rev "$latest_tag" go-enry enry)"
    commit_sha="$(jq -r '.rev' <<< "$prefetch_output")"
    source_hash="$(jq -r '.hash' <<< "$prefetch_output")"

    nixfile="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" enry).file" | tr -d '"')"
    sed -i "$nixfile" \
      -e "s|version = \".*\";|version = \"''${latest_tag#v}\";|" \
      -e "s|commitSha = \".*\"; # matches version|commitSha = \"$commit_sha\"; # matches version|" \
      -e "s|hash = \"sha256-.*\";|hash = \"$source_hash\";|"
  '';

  meta = {
    description = "Programming language detector based on go-enry/go-enry/v2 library";
    mainProgram = "enry";
    homepage = "https://github.com/go-enry/enry";
    changelog = "https://github.com/go-enry/enry/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dvcorreia ];
  };
})
