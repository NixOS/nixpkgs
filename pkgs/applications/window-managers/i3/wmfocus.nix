{ lib, fetchFromGitHub, rustPlatform
, xorg, python3, pkg-config, cairo, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fZbsKu7C+rqggaFVSDNIGDAgn23M7mi+1jhV85s1Co8=";
  };

  cargoSha256 = "sha256-ejzVJdtOXBPe+14g4aJFBMCvXkmNia9dNAk/BVQ2ZSQ=";

  nativeBuildInputs = [ python3 pkg-config ];
  buildInputs = [ cairo libxkbcommon xorg.xcbutilkeysyms ];

  # For now, this is the only available featureset. This is also why the file is
  # in the i3 folder, even though it might be useful for more than just i3
  # users.
  cargoBuildFlags = [ "--features i3" ];

  meta = with lib; {
    description = "Visually focus windows by label";
    homepage = "https://github.com/svenstaro/wmfocus";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
  };
}
