{ lib, fetchFromGitHub, rustPlatform, pkg-config, keybinder3, gtk3 }:

rustPlatform.buildRustPackage rec {
  pname = "findex";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "mdgaziur";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KaT6lEbrUelv/f9bIBW4bSCuExFu4b7XI7hcrO4mD0M=";
  };

  cargoHash = "sha256-7A+EF88DJrgsKPOJt2xaBnWSMkyhpFImyZmnHcyp+Dw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    keybinder3
  ];

  meta = with lib; {
    description = "Highly customizable application finder written in Rust and uses Gtk3";
    homepage = "https://github.com/mdgaziur/findex";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.pinkcreeper100 ];
  };
}
