{ lib, fetchFromGitHub, rustPlatform
, xorg, python3, pkg-config, cairo, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "09xffklpz62h6yiksxdlv3a9s1z0wr3ax9syl399avwdmq3c0y49";
  };

  cargoSha256 = "0fmz3q3yadymbqnkdhjd2z2g4zgf3z81ccixwywndd9zb7p47zdr";

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
