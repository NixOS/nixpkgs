{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rshijack";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "rshijack";
    rev = "v${version}";
    sha256 = "sha256-vTbjb0tm6jCP9+QWG5R83v31W6RUgSEv96iR37QdnFo=";
  };

  cargoHash = "sha256-wRy+bSi6XxbbvxqE5PFWs4xW1zfkvTHyyGgRZCOU7cY=";

  meta = with lib; {
    description = "TCP connection hijacker";
    homepage = "https://github.com/kpcyrd/rshijack";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.unix;
    mainProgram = "rshijack";
  };
}
