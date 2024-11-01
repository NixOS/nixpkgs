{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "libcaesium";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "Lymphatus";
    repo = "libcaesium";
    rev = version;
    hash = "sha256-DfzvH3abgTLa/CCZeXV3ypiPLfGVksJPOIr851cbRAk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  postInstall = ''
    # Not meant for installation.
    rm "$out/bin/main"
    rmdir "$out/bin"
  '';

  meta = with lib; {
    description = "Lossy/lossless image compression library";
    homepage = "https://github.com/Lymphatus/libcaesium";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
