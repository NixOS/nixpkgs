{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "meg";
  version = "0.3.0";

  vendorHash = "sha256-kQsGRmK7Qqz36whd6RI7Gecj40MM0o/fgRv7a+4yGZI=";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "meg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uhfPNpvuuC9kBYUBCGE6X46TeZ5QxIcnDQ4HRrn2mT4=";
  };

  meta = {
    homepage = "https://github.com/tomnomnom/meg";
    description = "Fetch many paths for many hosts without flooding hosts";
    mainProgram = "meg";
    maintainers = with lib.maintainers; [ averagebit ];
    license = lib.licenses.mit;
  };
})
