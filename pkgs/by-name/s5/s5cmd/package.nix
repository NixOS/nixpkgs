{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "s5cmd";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "peak";
    repo = "s5cmd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+wSVJkXmu+1BzvO1o31jhKZLXeG7y+YkABIZZ1TlK/g=";
  };

  vendorHash = null;

  # Skip e2e tests requiring network access
  excludedPackages = [ "./e2e" ];

  meta = {
    homepage = "https://github.com/peak/s5cmd";
    description = "Parallel S3 and local filesystem execution tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomberek ];
    mainProgram = "s5cmd";
  };
})
