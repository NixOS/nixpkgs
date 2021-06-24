{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "xplr";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = name;
    rev = "v${version}";
    sha256 = "06n1f4ccvy3bpw0js164rjclp0qy72mwdqm5hmvnpws6ixv78biw";
  };

  cargoSha256 = "0n9sgvqb194s5bzacr7dqw9cy4z9d63wzcxr19pv9pxpafjwlh0z";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
