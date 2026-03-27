{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comrak";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Klux0l0onlkpRIeQPHKZZhLhYB5On2R8CivpByGSgEA=";
  };

  cargoHash = "sha256-AB4XcGERw9PmYpwMVV1mTjpEJmL4pV7iyZUhn5GWflc=";

  meta = {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${finalAttrs.version}/changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      kivikakk
    ];
  };
})
