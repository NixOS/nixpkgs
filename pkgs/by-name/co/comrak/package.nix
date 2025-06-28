{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-czdX4Xfh5vD0d30QhxtTnzmwHkrX86fw8dVIx5b5J2c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QeMFaYpi8d88gpEbev485hGSCVTbEd7jbgkGSyGeM3g=";

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
