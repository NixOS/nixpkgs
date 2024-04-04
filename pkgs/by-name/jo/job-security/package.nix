{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "job-security";
  version = "unstable-0-2024-03-24";

  src = fetchFromGitHub {
    owner = "yshui";
    repo = "job-security";
    rev = "3881a4a0e66afe19cbdba3f43d0f85732796f977";
    hash = "sha256-mXmDzBsHdiim0bWrs0SvgtMZmKnYVz/RV9LNqPHHlnk=";
  };

  cargoHash = "sha256-W5evL36ByUUjvSwa3Nmf4MT2oZYoQ8kmchNOxUwmpuE=";

  meta = {
    description = "Job control from anywhere";
    homepage = "https://github.com/yshui/job-security";
    license = with lib.licenses; [ asl20 mit mpl20 ];
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "jobs";
    broken = stdenv.isDarwin;
  };
}
