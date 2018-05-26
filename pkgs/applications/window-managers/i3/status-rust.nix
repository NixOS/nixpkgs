{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, gperftools }:

rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = "0.9.0.2018-03-31";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = "18f99299bcd5b63da4e315c8d78622c4bbf59c45";
    sha256 = "1pfcq3f724ri6jzchkgf96zd7lb5mc882r64ffx634gqf3n8ch41";
  };

  cargoSha256 = "1197hp6d4z14j0r22bvw9ly294li0ivg6yfql4lgi27hbvzag71h";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus gperftools ];

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = https://github.com/greshake/i3status-rust;
    license = licenses.gpl3;
    maintainers = [ maintainers.backuitist ];
    platforms = platforms.linux;
  };
}
