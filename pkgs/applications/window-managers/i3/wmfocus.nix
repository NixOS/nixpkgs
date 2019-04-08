{ stdenv, fetchFromGitHub, rustPlatform,
  xorg, python3, pkgconfig, cairo, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = version;
    sha256 = "0jx0h2zyghs3bp4sg8f3vk5rkyprz2dqfqs0v72vmkp3cvgzxbvs";
  };

  cargoSha256 = "01ifrk6whvckys1kbj65cdwh976yn7dy9vpf4jybnlqripknab43";

  nativeBuildInputs = [ python3 pkgconfig ];
  buildInputs = [ cairo libxkbcommon xorg.xcbutilkeysyms ];

  # For now, this is the only available featureset. This is also why the file is
  # in the i3 folder, even though it might be useful for more than just i3
  # users.
  cargoBuildFlags = [ "--features i3" ];

  meta = with stdenv.lib; {
    description = "Visually focus windows by label";
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    license = licenses.mit;
    homepage = https://github.com/svenstaro/wmfocus;
  };
}
