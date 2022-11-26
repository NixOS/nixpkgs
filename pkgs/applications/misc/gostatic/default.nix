{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gostatic";
  version = "2.34";

  src = fetchFromGitHub {
    owner = "piranha";
    repo = pname;
    rev = version;
    hash = "sha256-rdbiIFRZcn9dVaF2anl2iy6FM6boz38vjn+hCpMwcis=";
  };

  vendorHash = "sha256-9YCt9crLuYjd+TUXJyx/EAYIMWM5TD+ZyzLeu0RMxVc=";

  meta = with lib; {
    description = "Fast static site generator";
    homepage = "https://github.com/piranha/gostatic";
    license = licenses.isc;
    maintainers = with maintainers; [ urandom ];
  };
}
