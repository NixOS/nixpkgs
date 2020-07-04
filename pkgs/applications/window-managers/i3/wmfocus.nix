{ stdenv, fetchFromGitHub, rustPlatform
, xorg, python3, pkgconfig, cairo, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = version;
    sha256 = "17qdsqp9072yr7rcm6g1h620rff95ldawr8ldpkbjmkh0rc86skn";
  };

  cargoSha256 = "1nsdvzrsgprwq7lsvfpymqslhggdzfk3840y8x92qjb0l2g4jhw1";

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
