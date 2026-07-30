{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rshijack";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "rshijack";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vTbjb0tm6jCP9+QWG5R83v31W6RUgSEv96iR37QdnFo=";
  };

  cargoHash = "sha256-wRy+bSi6XxbbvxqE5PFWs4xW1zfkvTHyyGgRZCOU7cY=";

  meta = {
    description = "TCP connection hijacker";
    homepage = "https://github.com/kpcyrd/rshijack";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ xrelkd ];
    platforms = lib.platforms.unix;
    mainProgram = "rshijack";
  };
})
