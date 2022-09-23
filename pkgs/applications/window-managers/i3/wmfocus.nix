{ lib, fetchFromGitHub, rustPlatform
, xorg, python3, pkg-config, cairo, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HrS+C/6KDG2Rn/3u/mMmp4vzQ5YAHUFL4HFecteuzsc=";
  };

  cargoSha256 = "sha256-EzgYnfUgwK2ldzrlqe9N9jeGgK+RzQPjbOjJCGEkcwE=";

  nativeBuildInputs = [ python3 pkg-config ];
  buildInputs = [ cairo libxkbcommon xorg.xcbutilkeysyms ];

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
