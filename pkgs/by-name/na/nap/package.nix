{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nap";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "nap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1xzQXY1CfN7fQtqZF4NXbh8mfYmUjiUAlYzbcD/6eiw=";
  };

  vendorHash = "sha256-puCqql77kvdWTcwp8z6LExBt/HbNRNe0f+wtM0kLoWM=";

  excludedPackages = ".nap";

  meta = {
    description = "Code snippets in your terminal";
    mainProgram = "nap";
    homepage = "https://github.com/maaslalani/nap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      phdcybersec
    ];
  };
})
