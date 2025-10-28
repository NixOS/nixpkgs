{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writeScript,
}:

let
  commitHash = "f10711437bfbb25b15506eb69dde24bb7decd222"; # matches tag release
in
buildGoModule (finalAttrs: {
  pname = "enry";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "go-enry";
    repo = "enry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JSYOCdWZnCM4Kq3EFkS7XZ5n0ahkR+A8omI4z1S45z8=";
  };

  vendorHash = "sha256-tUDhpeXlKpo1jnNyk0U3CcXroOlv7lHVUxc1wAnysG4=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${commitHash}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = writeScript "update-enry" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq nix-update

    set -eu -o pipefail

    gh_metadata="$(curl -sS https://api.github.com/repos/go-enry/enry/tags)"
    version="$(echo "$gh_metadata" | jq -r '.[] | .name' | sort --version-sort | tail -1)"
    commit_hash="$(echo "$gh_metadata" | jq -r --arg ver "$version" '.[] | select(.name == $ver).commit.sha')"

    filename="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" enry).file" | tr -d '"')"
    sed -i "s/commitHash = \"[^\"]*\"/commitHash = \"$commit_hash\"/" $filename

    nix-update enry
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
