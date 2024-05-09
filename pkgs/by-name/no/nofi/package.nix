{ lib, rustPlatform, fetchFromGitHub, dbus, pkg-config}:

rustPlatform.buildRustPackage rec {
  pname = "nofi";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "ellsclytn";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hQYIcyNCxb8qVpseNsmjyPxlwbMxDpXeZ+H1vpv62rQ=";
  };

  cargoHash = "sha256-0TYIycuy2LIhixVvH++U8CbmfQugc+0TF8DTiViWSbE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "An interruption-free notification system for Linux";
    homepage = "https://github.com/ellsclytn/nofi/";
    changelog = "https://github.com/ellsclytn/nofi/raw/v${version}/CHANGELOG.md";
    license = [ licenses.asl20 /* or */ licenses.mit ];
    mainProgram = "nofi";
    maintainers = [ maintainers.magnetophon ];
  };
}
