{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gostatic";
  version = "2.35";

  src = fetchFromGitHub {
    owner = "piranha";
    repo = pname;
    rev = version;
    hash = "sha256-pxk9tauB7u0oe6g4maHh+dREZXKwMz44v3KB43yYW6c=";
  };

  vendorHash = "sha256-9YCt9crLuYjd+TUXJyx/EAYIMWM5TD+ZyzLeu0RMxVc=";

  meta = with lib; {
    description = "Fast static site generator";
    homepage = "https://github.com/piranha/gostatic";
    license = licenses.isc;
    maintainers = with maintainers; [ urandom ];
  };
}
