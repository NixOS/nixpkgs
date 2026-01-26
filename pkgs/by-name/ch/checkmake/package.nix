{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  pandoc,
  go,
}:

buildGoModule (finalAttrs: {
  pname = "checkmake";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "checkmake";
    repo = "checkmake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W+4bKERQL4nsPxrcCP19uYAwSw+tK9mAQp/fufzYcYg=";
  };

  vendorHash = "sha256-Iv3MFhHnwDLIuUH7G6NYyQUSAaivBYqYDWephHnBIho=";

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.buildTime=1970-01-01T00:00:00Z"
    "-X=main.builder=nixpkgs"
    "-X=main.goversion=go${go.version}"
  ];

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    substituteInPlace man/man1/checkmake.1.md \
      --replace REPLACE_DATE 1970-01-01T00:00:00Z
  '';

  postBuild = ''
    pandoc man/man1/checkmake.1.md -st man -o man/man1/checkmake.1
  '';

  postInstall = ''
    installManPage man/man1/checkmake.1
  '';

  meta = {
    description = "Linter and analyzer for Makefiles";
    mainProgram = "checkmake";
    homepage = "https://github.com/checkmake/checkmake";
    changelog = "https://github.com/checkmake/checkmake/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    longDescription = ''
      checkmake is a linter for Makefiles. It scans Makefiles for potential issues based on configurable rules.
    '';
    maintainers = with lib.maintainers; [ lafrenierejm ];
  };
})
