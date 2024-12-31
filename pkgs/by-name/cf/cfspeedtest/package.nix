{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7FKUP6ZCIGmP/WX6lUwrUT7QEVo/LGJz46ZmqPeRTW8=";
  };

  cargoHash = "sha256-gckl2WHpuu7Gcubx/VEpHNW7jT76r9QHaAociQh+Zrc=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
