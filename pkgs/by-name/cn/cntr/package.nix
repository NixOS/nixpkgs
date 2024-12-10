{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-ErGratd1RCynE+iS+qn9feJi5o9f94lUNJZfy4XAjkc=";
  };

  cargoHash = "sha256-4EDAQ0MG0BTN0L3W4Jm0IdVY8vj5U3faO+ruUjLMBMY=";

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
