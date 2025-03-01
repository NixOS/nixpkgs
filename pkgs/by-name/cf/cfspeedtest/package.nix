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
    tag = "v${version}";
    hash = "sha256-7FKUP6ZCIGmP/WX6lUwrUT7QEVo/LGJz46ZmqPeRTW8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vp6+rdF6YVzeuAkLFnnkQFlc3gxqZn9MDGLIbiMpIwE=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
