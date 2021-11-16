{ lib
, rustPlatform
, fetchFromGitHub
, glib
, pkg-config
, wrapGAppsHook
, gtk3
}:

rustPlatform.buildRustPackage rec {
  pname = "image-roll";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "weclaw1";
    repo = pname;
    rev = version;
    sha256 = "007jzmrn4cnqbi6fy5lxanbwa4pc72fbcv9irk3pfd0wspp05s8j";
  };

  cargoSha256 = "sha256-dRRBfdGTXtoNbp7OWqOdNECXHCpj0ipkCOvcdekW+G4=";

  nativeBuildInputs = [ glib pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 ];

  meta = with lib; {
    description = "Simple and fast GTK image viewer with basic image manipulation tools";
    homepage = "https://github.com/weclaw1/image-roll";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
