{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "flamelens";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "flamelens";
    tag = "v${version}";
    hash = "sha256-cvsBeV9pdgr8V+82Fw/XZS1Ljq/7ff4JYMHnNxqNvOM=";
  };

  cargoHash = "sha256-FIIt8RwPaPrVG3D9FoMjR4L81NzUrKZsAeW2AJkBG1o=";

  meta = {
    description = "Interactive flamegraph viewer in the terminal";
    homepage = "https://github.com/YS-L/flamelens";
    changelog = "https://github.com/YS-L/flamelens/releases/tag/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.averdow ];
  };
}
