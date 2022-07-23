{ lib
, fetchFromGitHub
, buildGoModule
, nix-update-script
, testers
, gostatic
}:

buildGoModule rec {
  pname = "gostatic";
  version = "2.35";

  src = fetchFromGitHub {
    owner = "piranha";
    repo = pname;
    rev = version;
    sha256 = "sha256-pxk9tauB7u0oe6g4maHh+dREZXKwMz44v3KB43yYW6c=";
  };

  vendorSha256 = "sha256-9YCt9crLuYjd+TUXJyx/EAYIMWM5TD+ZyzLeu0RMxVc=";

  ldflags = [ "-s" "-w" ];

  passthru = {
    updateScript = nix-update-script { attrPath = pname; };
    tests.version = testers.testVersion {
      package = gostatic;
      command = "gostatic -V";
    };
  };

  meta = with lib; {
    description = "Fast static site generator";
    homepage = "https://github.com/piranha/gostatic";
    changelog = "https://github.com/piranha/gostatic/releases/tag/${src.rev}";
    license = licenses.isc;
    maintainers = with maintainers; [ zendo ];
  };
}
