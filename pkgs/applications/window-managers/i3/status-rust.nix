{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, libpulseaudio, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rust";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "greshake";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d2xigm932x6pc9z24g5cg8xq2crd9n3wq1bwi96h35w799lagjg";
  };

  cargoPatches = [
    # https://github.com/greshake/i3status-rust/pull/732/ (Update Cargo.lock)
    (fetchpatch {
      url = "https://github.com/greshake/i3status-rust/commit/7762a5c7ad668272fb8bb8409f12242094b032b8.patch";
      sha256 = "097f6w91cn53cj1g3bbdqm9jjib5fkb3id91jqvq88h43x14b8zb";
    })
  ];

  cargoSha256 = "1k50yhja73w91h6zjmkb5kh1hknpjzrqd3ilvjjyynll513m1sfd";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus libpulseaudio ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = "https://github.com/greshake/i3status-rust";
    license = licenses.gpl3;
    maintainers = with maintainers; [ backuitist globin ma27 ];
    platforms = platforms.linux;
  };
}
