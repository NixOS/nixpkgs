{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cocom";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "LamdaLamdaLamda";
    repo = "cocom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kdkpal+jPudmkzNM1dVa5L89YZ61Us17sEk9Iwb2sNk=";
  };

  cargoHash = "sha256-SwrweqDUPQVhqSZxkwvu+fPUka9/5KG8cy1YeG1Nm4o=";

  # Tests require network access
  doCheck = false;

  meta = {
    description = "NTP client";
    homepage = "https://github.com/LamdaLamdaLamda/cocom";
    changelog = "https://github.com/LamdaLamdaLamda/cocom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cocom";
  };
})
