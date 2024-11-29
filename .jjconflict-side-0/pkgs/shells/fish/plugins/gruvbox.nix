{ lib , buildFishPlugin , fetchFromGitHub }:
buildFishPlugin {
  pname = "gruvbox";
  version = "0-unstable-2021-10-12";
  src = fetchFromGitHub {
    owner = "jomik";
    repo = "fish-gruvbox";
    rev = "80a6f3a7b31beb6f087b0c56cbf3470204759d1c";
    hash = "sha256-vL2/Nm9Z9cdaptx8sJqbX5AnRtfd68x4ZKWdQk5Cngo=";
  };
  meta = {
    description = "Gruvbox theme for fish shell";
    homepage = "https://github.com/Jomik/fish-gruvbox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ msladecek ];
  };
}
