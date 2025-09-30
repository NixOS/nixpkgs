{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smfh";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "smfh";
    tag = finalAttrs.version;
    hash = "sha256-/9Ww10kYopxfCNNnNDwENTubs7Wzqlw+O6PJAHNOYQw=";
  };

  cargoHash = "sha256-MpqbmhjNsE1krs7g3zWSXGxzb4G/A+cz/zxD2Jk2HC8=";

  meta = {
    description = "Sleek Manifest File Handler";
    homepage = "https://github.com/feel-co/smfh";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      arthsmn
      gerg-l
    ];
    mainProgram = "smfh";
  };
})
