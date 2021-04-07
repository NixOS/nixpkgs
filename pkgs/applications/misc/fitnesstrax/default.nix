{ fetchFromGitHub
, glib
, gtk3
, lib
, rustPlatform
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "fitnesstrax";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "luminescent-dreams";
    repo = "fitnesstrax";
    rev = "${pname}-${version}";
    sha256 = "1k6zhnbs0ggx7q0ig2abcnzprsgrychlpvsh6d36dw6mr8zpfkp7";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    glib
    gtk3
  ];

  buildInputs = [
    glib
    gtk3
  ];

  cargoSha256 = "1xgyyxd2kz21xan0pk7rbxiym90s7m2qrzg2ddilcszva60bxdd9";

  postInstall = ''
    mkdir -p $out/share/glib-2.0/schemas
    cp -r $src/share/* $out/share/
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "Privacy-first fitness tracking";
    homepage = "https://github.com/luminescent-dreams/fitnesstrax";
    license = licenses.bsd3;
    maintainers = with maintainers; [ savannidgerinel ];
  };
}
