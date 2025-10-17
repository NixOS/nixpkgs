{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-qwwROwIFG9/pX8t92EHriaN3O4Z2IpQGylVKhbp/0IU=";
  };

  cargoHash = "sha256-Ybyrk+I0nzHFkEaWDovTOGPC26i7BXcNtFgFjmCHIwM=";

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
