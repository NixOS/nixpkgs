{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gilt-rs";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "simonhollingshead";
    repo = "gilt-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rW5uHRqGq8CBl+4eZo/1W0T7km+mRI2oFN0FU30To8Q=";
  };

  cargoHash = "sha256-oVHNBg6umFsPWBVIZEMBc6AB1SFqHMAxwuTa3cIyKjE=";

  __structuredAttrs = true;

  meta = {
    description = "Tool for calculating which UK Gilt will give the best return if held to maturity";
    homepage = "https://github.com/simonhollingshead/gilt-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
