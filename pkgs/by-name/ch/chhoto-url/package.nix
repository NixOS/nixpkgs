{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chhoto-url";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "SinTan1729";
    repo = "chhoto-url";
    tag = finalAttrs.version;
    hash = "sha256-n8fCQeY0gIyZuACKWa8Fk9TQ680PpVS2MHMFy7UgDwk=";
    fetchLFS = true;
  };

  sourceRoot = "${finalAttrs.src.name}/actix";

  postPatch = ''
    substituteInPlace src/{main.rs,services/get.rs,services/utils.rs} \
      --replace-fail "./resources/" "${placeholder "out"}/share/chhoto-url/resources/"
  '';

  cargoHash = "sha256-9EVGsOipx9ObygpM37iZYLnhYjSMHFhHTDvjHkLWLz8=";

  postInstall = ''
    mkdir -p $out/share/chhoto-url
    cp -r ${finalAttrs.src}/resources $out/share/chhoto-url/resources
  '';

  passthru = {
    tests = { inherit (nixosTests) chhoto-url; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple, blazingly fast, selfhosted URL shortener with no unnecessary features";
    homepage = "https://github.com/SinTan1729/chhoto-url";
    changelog = "https://github.com/SinTan1729/chhoto-url/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "chhoto-url";
  };
})
