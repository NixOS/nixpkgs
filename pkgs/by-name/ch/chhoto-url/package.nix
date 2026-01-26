{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chhoto-url";
  version = "6.5.5";

  src = fetchFromGitHub {
    owner = "SinTan1729";
    repo = "chhoto-url";
    tag = finalAttrs.version;
    hash = "sha256-Kr/DpxptU3j3Q97G+5fG5y7oLrpK7KaqlDv0TtsAl4E=";
  };

  sourceRoot = "${finalAttrs.src.name}/actix";

  postPatch = ''
    substituteInPlace src/{main.rs,services.rs} \
      --replace-fail "./resources/" "${placeholder "out"}/share/chhoto-url/resources/"
  '';

  cargoHash = "sha256-3WZgjf2ytnnTKVR0E6n3d4WhHS/cjgEgfENtOpBf57w=";

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
