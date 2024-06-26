{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-spa4qPEhpNSZIk16jeH9YEr4g9JcVmpetHz72A/ZAPY=";
  };

  cargoHash = "sha256-YN8EtUXKtT8Xc0RnW7QqL+awyWy5xFKWhYMxgYG28I4=";

  passthru.tests = nixosTests.cntr;

  meta = with lib; {
    description = "Container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
    mainProgram = "cntr";
  };
}
