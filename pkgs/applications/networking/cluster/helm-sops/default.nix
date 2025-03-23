{ lib, stdenv, buildGoModule, fetchFromGitHub, helm, sops }:

buildGoModule rec {
  pname = "helm-sops";
  version = "20250205-1";  # Replace with the correct version

  src = fetchFromGitHub {
    owner = "camptocamp";  # Replace with the correct owner
    repo = "helm-sops";
    rev = "20250205-1";
    sha256 = "sha256-xkHv+PM2acwk9uwAHlVgBbJKhofAU60KJykMEx7Zq8I=";  # Replace with the correct sha256 hash
  };

  vendorHash = "sha256-jynNpi9XRaLLW1rbvFTgX5CHDoJxagFpx9nGK0F2H0Y=";

  nativeBuildInputs = [ helm sops ];

  meta = with lib; {
    description = "A Helm plugin to encrypt secrets with SOPS";
    homepage = "https://github.com/camptocamp/helm-sops";  # Replace with the correct homepage URL
    license = licenses.gpl3Only;  # Replace with the correct license
    maintainers = with maintainers; [ mrupnikm ];  # Replace with your GitHub username
  };
}
