{ lib
, fetchFromGitHub
, rustPlatform
, libX11
, libXft
, libXinerama
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

  # The x11_dl crate dlopen()s these libraries, so we have to inject them into rpath.
  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [ libX11 libXft libXinerama ]} $out/bin/rlaunch
  '';

  meta = with lib; {
    description = "A lightweight application launcher for X11";
    homepage = "https://github.com/PonasKovas/rlaunch";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
