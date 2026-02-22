{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sizelint";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "sizelint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1k1+7fVWhflEKyhOlb7kMn2xqeAM6Y5N9uHtOJvVn4A=";
  };

  nativeCheckInputs = [ git ];

  cargoHash = "sha256-Z+pmlp/0LlKfc4QLosePw7TdLFYe6AnAVOJSw2DzlfI=";

  meta = {
    description = "Lint your file tree based on file sizes";
    homepage = "https://github.com/a-kenji/sizelint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "sizelint";
  };
})
