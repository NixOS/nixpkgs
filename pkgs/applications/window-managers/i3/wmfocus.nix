{ lib, fetchFromGitHub, rustPlatform
, xorg, python3, pkg-config, cairo, expat, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-94MgE2j8HaS8IyzHEDtoqTls2A8xD96v2iAFx9XfMcw=";
  };

  cargoHash = "sha256-sSJAlDe1vBYs1vZW/X04cU14Wj1OF4Jy8oI4uWkrEjk=";

  nativeBuildInputs = [ python3 pkg-config ];
  buildInputs = [ cairo expat libxkbcommon xorg.xcbutilkeysyms ];

  # For now, this is the only available featureset. This is also why the file is
  # in the i3 folder, even though it might be useful for more than just i3
  # users.
  buildFeatures = [ "i3" ];

  meta = with lib; {
    description = "Visually focus windows by label";
    homepage = "https://github.com/svenstaro/wmfocus";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
  };
}
