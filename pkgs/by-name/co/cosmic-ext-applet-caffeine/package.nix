{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-caffeine";
  version = "0-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "tropicbliss";
    repo = "cosmic-ext-applet-caffeine";
    rev = "0b50a109495d02ab8c99a501d2dd7575c6fabc1b";
    hash = "sha256-Z84LqsPVGd7PfOUmC1iJWgTGrl6FicaxZHwTZmgmAyk=";
  };

  cargoHash = "sha256-TC7WNJUxGZpfDbDgnifBSZM7SvN2/Iw0HRXWPDXnDBM=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-caffeine"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Caffeine Applet for the COSMIC desktop";
    homepage = "https://github.com/tropicbliss/cosmic-ext-applet-caffeine";
    license = lib.licenses.mit;
    mainProgram = "cosmic-ext-applet-caffeine";
    maintainers = [ lib.maintainers.HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
