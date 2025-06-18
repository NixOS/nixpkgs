{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "s5cmd";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "peak";
    repo = "s5cmd";
    rev = "v${version}";
    hash = "sha256-+wSVJkXmu+1BzvO1o31jhKZLXeG7y+YkABIZZ1TlK/g=";
  };

  vendorHash = null;

  # Skip e2e tests requiring network access
  excludedPackages = [ "./e2e" ];

  meta = with lib; {
    homepage = "https://github.com/peak/s5cmd";
    description = "Parallel S3 and local filesystem execution tool";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
    mainProgram = "s5cmd";
  };
}
