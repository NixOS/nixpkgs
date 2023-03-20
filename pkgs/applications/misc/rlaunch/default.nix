{ lib
, fetchFromGitHub
, fetchpatch
, rustPlatform
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "rlaunch";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "PonasKovas";
    repo = pname;
    rev = version;
    sha256 = "1w8qvny72l5358wnk4dmqnrv4mrpzxrzf49svav9grzxzzf8mqy2";
  };

  cargoSha256 = "00lnw48kn97gp45lylv5c6v6pil74flzpsq9k69xgvvjq9yqjzrx";

  patches = [
    # Fixes "error[E0308]: mismatched types; expected `u8`, found `i8`" on aarch64
    # Remove with next version update
    (fetchpatch {
      url = "https://github.com/PonasKovas/rlaunch/commit/f78f36876bba45fe4e7310f58086ddc63f27a57e.patch";
      hash = "sha256-rTS1khw1zt3i1AJ11BhAILcmaohAwVc7Qfl6Fc76Kvs=";
    })
  ];

  # The x11_dl crate dlopen()s these libraries, so we have to inject them into rpath.
  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath (with xorg; [ libX11 libXft libXinerama ])} $out/bin/rlaunch
  '';

  meta = with lib; {
    description = "A lightweight application launcher for X11";
    homepage = "https://github.com/PonasKovas/rlaunch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danc86 ];
  };
}
