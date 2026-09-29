{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pdfrip";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "mufeedvh";
    repo = "pdfrip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VytsSVcKx1/A9BSlmRdkD61txDvFOaSfG411565q9eY=";
  };

  cargoHash = "sha256-JKZ29fW/B4rJe6g6VKkgZdxlA2eaaAgjztFQ/5kDF1o=";

  meta = {
    description = "PDF password cracking utility";
    homepage = "https://github.com/mufeedvh/pdfrip";
    changelog = "https://github.com/mufeedvh/pdfrip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pdfrip";
  };
})
