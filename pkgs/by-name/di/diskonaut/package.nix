{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "diskonaut";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "diskonaut";
    rev = version;
    sha256 = "1pmbag3r2ka30zmy2rs9jps2qxj2zh0gy4a774v9yhf0b6qjid54";
  };

  cargoHash = "sha256-S/ne3iTEnlA3AqcPg3geLzV4bYVuYPjMCITSVJFnWYI=";

  # 1 passed; 44 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Terminal disk space navigator";
    homepage = "https://github.com/imsnif/diskonaut";
    license = licenses.mit;
    maintainers = with maintainers; [
      evanjs
      figsoda
    ];
    mainProgram = "diskonaut";
  };
}
