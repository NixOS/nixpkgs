{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "go-grip";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "chrishrb";
    repo = "go-grip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-02d7olJvl3V7ATkURe8KkKWUTkKUHdn9ngIfoEIDtHw=";
  };

  vendorHash = "sha256-Bc1hWmz5Auh55CzwF83k4Q4eVdik/SPWKT7aRgUh+b4=";

  meta = {
    description = "Preview Markdown files locally before committing them";
    homepage = "https://github.com/chrishrb/go-grip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "go-grip";
  };
})
