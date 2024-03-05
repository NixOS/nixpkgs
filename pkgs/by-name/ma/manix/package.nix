{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "manix";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "manix";
    rev = "v${version}";
    hash = "sha256-b/3NvY+puffiQFCQuhRMe81x2wm3vR01MR3iwe/gJkw=";
  };

  cargoHash = "sha256-45cb0yO/ypGLcvEgPOkN6Py99yqK09xnCmMOLOOYYSA=";

  meta = with lib; {
    description = "A fast CLI documentation searcher for Nix";
    homepage = "https://github.com/nix-community/manix";
    license = licenses.mpl20;
    maintainers = with maintainers; [ iogamaster lecoqjacob ];
    mainProgram = "manix";
  };
}
