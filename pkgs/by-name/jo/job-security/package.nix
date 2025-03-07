{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "job-security";
  version = "0-unstable-2024-04-07";

  src = fetchFromGitHub {
    owner = "yshui";
    repo = "job-security";
    rev = "9b621cb0be437c709e398d31934b864a09d2a1d5";
    hash = "sha256-KPnLVKz10SuVcG0CCFWxWnjhf9gHHPCRZw6AW9/gAmk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-g+n0C8tkEuixbRo48cMOYPXcYt+Ur1TP6fFTYlI4fVg=";

  meta = {
    description = "Job control from anywhere";
    homepage = "https://github.com/yshui/job-security";
    license = with lib.licenses; [
      asl20
      mit
      mpl20
    ];
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "jobs";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
