{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.23.5";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "sha256-/f68TlNuaEyPDSBpMmOjZkLF6Is2+oYfbWQqQOnsR4M=";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "sha256-sgwT0CLFdmzh7dezVE5tcmGCXqxnGLT00IDIQJl6pHw=";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
