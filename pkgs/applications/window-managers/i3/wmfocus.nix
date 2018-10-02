{ stdenv, fetchFromGitHub, rustPlatform,
  xorg, python3, pkgconfig, cairo, libxkbcommon }:
let
  pname = "wmfocus";
  version = "1.0.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  name = "${pname}-${version}";

  nativeBuildInputs = [ python3 pkgconfig ];
  buildInputs = [ cairo libxkbcommon xorg.xcbutilkeysyms ];

  # For now, this is the only available featureset. This is also why the file is
  # in the i3 folder, even though it might be useful for more than just i3
  # users.
  cargoBuildFlags = ["--features i3"];

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = version;
    sha256 = "14yxg2jiqx7gng677sbmvv0a0msb9wpvp3qh8h3nkq0vi17ds668";
  };

  cargoSha256 = "0lwzw8gf970ybblaxxkwn3pxrncxp0hhvykffbzirs7fic4fnvsg";

  meta = with stdenv.lib; {
    description = ''
      Tool that allows you to rapidly choose a specific window directly
      without having to use the mouse or directional keyboard navigation.
    '';
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    license = licenses.mit;
    homepage = https://github.com/svenstaro/wmfocus;
  };
}
