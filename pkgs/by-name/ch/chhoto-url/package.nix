{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chhoto-url";
  version = "7.5.1";

  src = fetchFromGitHub {
    owner = "SinTan1729";
    repo = "chhoto-url";
    tag = finalAttrs.version;
    hash = "sha256-FAYbqNZVPUpfBKOn+cXvk5d8o29M9+d8t5ecihCQ4aY=";
    fetchLFS = true;
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  postPatch = ''
    substituteInPlace src/{main.rs,services/get.rs,services/utils.rs} \
      --replace-fail "./frontend/" "${placeholder "out"}/share/chhoto-url/frontend/"
    substituteInPlace Cargo.toml \
      --replace-fail 'rust-version = "1.96"' 'rust-version = "1.95"'
  '';

  cargoHash = "sha256-C+eH6lrFSpE7zuR3fyyP44KG/rV0N2Uh4E7She0HuEA=";

  postInstall = ''
    mkdir -p $out/share/chhoto-url
    cp -r ${finalAttrs.src}/frontend $out/share/chhoto-url/frontend
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
