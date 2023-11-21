{ lib, fetchFromGitHub, rustPlatform, fetchurl, runCommand }:

rustPlatform.buildRustPackage rec {
  pname = "flaca";
  version = "2.4.6";

  src =
    let
      source = fetchFromGitHub {
        owner = "Blobfolio";
        repo = pname;
        rev = "v${version}";
        hash = "sha256-uybEo098+Y92b2P9CniKFmaV8hQZFuOSthgQRGZ/ncc=";
      };
      lockFile = fetchurl {
        url = "https://github.com/Blobfolio/flaca/releases/download/v${version}/Cargo.lock";
        hash = "sha256-xAjpw71HgS6fILg5zNuc43s0fIqYcoUMMbCH65xrlww=";
      };
    in
    runCommand "source" { } ''
      cp -R ${source} $out
      chmod +w $out
      cp ${lockFile} $out/Cargo.lock
    '';

  cargoHash = "sha256-z6hw5xUcEakAzoT2ZUD/+PDCTCWkZqfPCiIZQQ7Ul54=";

  meta = with lib; {
    description = "A CLI tool to losslessly compress JPEG and PNG images";
    longDescription = "A CLI tool for x86-64 Linux machines that simplifies the task of maximally, losslessly compressing JPEG and PNG images for use in production web environments";
    homepage = "https://github.com/Blobfolio/flaca";
    maintainers = with maintainers; [ zzzsy ];
    platforms = platforms.linux;
    license = licenses.wtfpl;
  };
}
