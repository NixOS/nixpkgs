{ lib, fetchFromGitHub }:

fetchFromGitHub {
  pname = "gyroflow-lens-profiles";
  version = "2024-09-08";

  owner = "gyroflow";
  repo = "lens_profiles";
  rev = "a100b233a1df242d5bf1be06df2888a5852febf3";
  hash = "sha256-z994k2lozakaKNKcdrJKzTiMGeL9oJ70jFnEYgbutq4=";

  meta = with lib; {
    description = "Lens profile database for Gyroflow";
    homepage = "https://github.com/gyroflow/lens_profiles";
    license = licenses.cc0;
    maintainers = with maintainers; [ orivej ];
    platforms = lib.platforms.all;
  };
}
