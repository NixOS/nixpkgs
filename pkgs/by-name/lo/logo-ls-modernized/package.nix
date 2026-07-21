{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "logo-ls-modernized";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "orhnk";
    repo = "logo-ls-modernized";
    rev = "7bf4721811c2b7f08e2dfb7a1b5d40de39a315fa";
    hash = "sha256-javdn2UODcMXe094qn0KYs/oMTjtMWZCo9bUNH9Bb9c=";
  };

  proxyVendor = true;

  subPackages = [ "." ];

  vendorHash = "sha256-yEj0A3LLv/l8Iqnvj/H+TA6UPzETr+ph5Y9QcX4nmjw=";

  doCheck = false;

  meta = with lib; {
    description = "Modern ls command with beautiful icons and git integrations written in Go";
    homepage = "https://github.com/orhnk/logo-ls-modernized";
    license = licenses.mit;
    mainProgram = "logo-ls";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
