{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "nova-password";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = "nova-password";
    rev = "refs/tags/v${version}";
    hash = "sha256-pBew5c+wlXwMLDjgwwdOSUyTxPGpa9AwbhZni8FfTsQ=";
  };

  # The repo contains vendored dependencies
  vendorHash = null;

  meta = {
    description = "Decrypt the admin password generated for the VM in OpenStack";
    homepage = "https://github.com/sapcc/nova-password";
    license = lib.licenses.asl20;
    mainProgram = "nova-password";
    maintainers = with lib.maintainers; [ vinetos ];
    platforms = lib.platforms.all;
  };
}
