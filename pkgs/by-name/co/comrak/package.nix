{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-GYUMSn276XrGPIYRQf6+w3eIvKB5lMayBgSFyGb0DVw=";
  };

  cargoHash = "sha256-GxWhSYsCxOxcRbEtHj7V+4Wu2uoZjTpG04NFidS8sSQ=";

  meta = {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${version}/changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      figsoda
      kivikakk
    ];
  };
}
