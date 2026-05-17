{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pipes-rs";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "lhvy";
    repo = "pipes-rs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7FdC/VY1ZO4E/qDdeKzsIai8h5ZgMrSr1C+Ny4fYh38=";
  };

  cargoHash = "sha256-TIVWl/9xSFsSXD9XzOHBvc/1HvI/radas00p4fZ/AzM=";

  doInstallCheck = true;

  installCheckPhase = ''
    if [[ "$("$out/bin/pipes-rs" --version)" == "pipes-rs ${finalAttrs.version}" ]]; then
      echo 'pipes-rs smoke check passed'
    else
      echo 'pipes-rs smoke check failed'
      return 1
    fi
  '';

  meta = {
    description = "Over-engineered rewrite of pipes.sh in Rust";
    mainProgram = "pipes-rs";
    homepage = "https://github.com/lhvy/pipes-rs";
    license = lib.licenses.blueOak100;
    maintainers = [ lib.maintainers.vanilla ];
  };
})
