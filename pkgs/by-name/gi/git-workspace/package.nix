{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sS452PCX2G49Q5tnScG+ySkUAhFctGsGZrMvQXL7WkY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iYT45iqKmx+t+xImbQuSv/nAvaiLNrLLqbe8zKAF4Jw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ misuzu ];
    mainProgram = "git-workspace";
  };
}
