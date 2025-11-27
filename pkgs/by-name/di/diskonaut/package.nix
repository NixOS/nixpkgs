{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "diskonaut";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "neunenak";
    repo = "diskonaut";
    rev = version;
    sha256 = "1fvwmz941154rlsjbj80sa5r1m5c7ap9rbvynk8qyqli2nm6kzcz";
  };

  cargoHash = "sha256-C2pGyTef8IgF2FSBXRlLJCW3IgJ1d+2uxF6nelYF6AM=";

  # 1 passed; 44 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Terminal disk space navigator";
    homepage = "https://github.com/neunenak/diskonaut";
    license = licenses.mit;
    maintainers = with maintainers; [
      evanjs
    ];
    mainProgram = "diskonaut";
  };
}
