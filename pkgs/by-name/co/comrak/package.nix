{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4aNV9FKqRNirYBMXIgAXjwS2FBCgLuxdhWQCvZbmZp4=";
  };

  cargoHash = "sha256-K3dMn90E/0PxlE+6nBAECuHSsDM/TlAIQGF/y1SMm8k=";

  meta = with lib; {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      figsoda
      kivikakk
    ];
  };
}
