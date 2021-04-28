{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "xplr";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = name;
    rev = "v${version}";
    sha256 = "1j417g0isy3cpxdb2wrvrvypnx99qffi83s4a98791wyi8yqiw6b";
  };

  cargoSha256 = "0kpwhk2f4czhilcnfqkw5hw2vxvldxqg491xkkgxjkph3w4qv3ji";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
