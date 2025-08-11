{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chhoto-url";
  version = "6.2.12";

  src = fetchFromGitHub {
    owner = "SinTan1729";
    repo = "chhoto-url";
    tag = finalAttrs.version;
    hash = "sha256-hV/YWxOPRTojVTFIXwzqImBKyQ1dCDq5+bgCdS7T1p0=";
  };

  sourceRoot = "${finalAttrs.src.name}/actix";

  postPatch = ''
    substituteInPlace src/{main.rs,services.rs} \
      --replace-fail "./resources/" "${placeholder "out"}/share/chhoto-url/resources/"
  '';

  cargoHash = "sha256-9wXbd56KOQ7suZqtg2cSFf2FGQJADFMHJbwAAxJ2V4g=";

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
