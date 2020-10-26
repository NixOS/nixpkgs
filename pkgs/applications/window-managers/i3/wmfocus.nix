{ stdenv, fetchFromGitHub, rustPlatform
, xorg, python3, pkgconfig, cairo, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "09xffklpz62h6yiksxdlv3a9s1z0wr3ax9syl399avwdmq3c0y49";
  };

  cargoSha256 = "0rczas6sgcppacz48xx7sarkvc4s2sgcdz6c661d7vcry1y46xms";

  nativeBuildInputs = [ python3 pkgconfig ];
  buildInputs = [ cairo libxkbcommon xorg.xcbutilkeysyms ];

  # For now, this is the only available featureset. This is also why the file is
  # in the i3 folder, even though it might be useful for more than just i3
  # users.
  cargoBuildFlags = [ "--features i3" ];

  meta = with stdenv.lib; {
    description = "Visually focus windows by label";
    homepage = "https://github.com/svenstaro/wmfocus";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
  };
}
