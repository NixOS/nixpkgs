{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cxt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vaibhav-mattoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "ubqM485fPSb/sGfsdq3Yzg0nFduaV7WcWjlBeExutFw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = with lib; {
    description = "Aggregates file/directory contents and sends them to the clipboard, a file, or stdout";
    homepage = "https://github.com/vaibhav-mattoo/cxt";
    license = licenses.mit;
    maintainers = with maintainers; [ vaibhav-mattoo ];
    platforms = platforms.all;
  };
}
