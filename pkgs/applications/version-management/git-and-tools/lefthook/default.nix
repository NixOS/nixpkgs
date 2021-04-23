{ lib, buildGoModule, fetchFromGitHub }:

# Currently `buildGo114Module` is passed as `buildGoModule` from
# `../default.nix`. Please remove the fixed 1.14 once a new release has been
# made and the issue linked below has been closed upstream.

# https://github.com/Arkweid/lefthook/issues/151

buildGoModule rec {
  pname = "lefthook";
  version = "0.7.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "evilmartians";
    repo = "lefthook";
    sha256 = "sha256-VrAkmLRsYNDX5VfAxsvjsOv1bv7Nk53OjdaJm/D2GRk=";
  };

  vendorSha256 = "sha256-XR7xJZfgt0Hx2DccdNlwEmuduuVU8IBR0pcIUyRhdko=";

  doCheck = false;

  meta = with lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/Arkweid/lefthook";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}
