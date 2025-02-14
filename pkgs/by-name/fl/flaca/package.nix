{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchurl,
  runCommand,
  lndir,
}:

rustPlatform.buildRustPackage rec {
  pname = "flaca";
  version = "3.2.0";

  src =
    let
      source = fetchFromGitHub {
        owner = "Blobfolio";
        repo = pname;
        rev = "v${version}";
        hash = "sha256-pT3CizoqMQe+JljuDbV7hQpUmG+fx/ES2reupeX60iY=";
      };
      lockFile = fetchurl {
        url = "https://github.com/Blobfolio/flaca/releases/download/v${version}/Cargo.lock";
        hash = "sha256-Ek33acdDA9iMgpyIdx12arKtPHoKaIrfh5GNdgT7ib0=";
      };
    in
    runCommand "source-with-lock" { nativeBuildInputs = [ lndir ]; } ''
      mkdir -p $out
      ln -s ${lockFile} $out/Cargo.lock
      lndir -silent ${source} $out
    '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-3NGW1GEwksu9Al/qOg3rfnFcfSyICTgKlPW10Y8q80Y=";

  meta = with lib; {
    description = "CLI tool to losslessly compress JPEG and PNG images";
    longDescription = "A CLI tool for x86-64 Linux machines that simplifies the task of maximally, losslessly compressing JPEG and PNG images for use in production web environments";
    homepage = "https://github.com/Blobfolio/flaca";
    changelog = "https://github.com/Blobfolio/flaca/releases/tag/v${version}";
    maintainers = with maintainers; [ zzzsy ];
    platforms = platforms.linux;
    license = licenses.wtfpl;
    mainProgram = "flaca";
  };
}
