{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sparsecat";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "svenwiltink";
    repo = "sparsecat";
    rev = "v${version}";
    hash = "sha256-2E5yPlLg/XtosiR//be7usDjOKWEWcAzgWFQc0nYYF0=";
  };

  vendorHash = "sha256-vxLqSmM6iSbWNlu0jz7CR9mqf9MMq3qAt26tOWwQRSc=";

  subPackages = [ "cmd/sparsecat" ];

  meta = {
    description = "CLI tool that reduces bandwidth usage when transmitting sparse files";
    homepage = "https://github.com/svenwiltink/sparsecat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilimnik ];
  };
}
