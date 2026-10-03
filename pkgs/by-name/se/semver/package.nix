{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "semver";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "catouc";
    repo = "semver-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ew90arj8EcoHXtaD86P7ijhM5sdMS0/JrZafkHg+cmw=";
  };

  vendorHash = null;
  nativeBuildInputs = [ git ];

  meta = {
    homepage = "https://github.com/catouc/semver-go";
    description = "Small CLI to fish out the current or next semver version from a git repository";
    maintainers = with lib.maintainers; [ catouc ];
    license = lib.licenses.mit;
    mainProgram = "semver";
  };
})
