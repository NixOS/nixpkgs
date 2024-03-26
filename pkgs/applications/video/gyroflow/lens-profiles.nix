{ lib, fetchFromGitHub }:

fetchFromGitHub {
  pname = "gyroflow-lens-profiles";
  version = "2023-12-01";

  owner = "gyroflow";
  repo = "lens_profiles";
  rev = "3e72169ae6b8601260497d7216d5fcbbc8b67194";
  hash = "sha256-18KtunSxTsJhBge+uOGBcNZRG3W26M/Osyxllu+N0UI=";

  meta = with lib; {
    description = "Lens profile database for Gyroflow";
    homepage = "https://github.com/gyroflow/lens_profiles";
    license = licenses.cc0;
    maintainers = with maintainers; [ orivej ];
    platforms = lib.platforms.all;
  };
}
