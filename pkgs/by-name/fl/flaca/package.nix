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
  version = "3.2.2";

  src =
    let
      source = fetchFromGitHub {
        owner = "Blobfolio";
        repo = pname;
        rev = "v${version}";
        hash = "sha256-7JZ9AqNyJ1GqonzAVUxVqdSRMydX1h0pHUZm1a/v1Mc=";
      };
      lockFile = fetchurl {
        url = "https://github.com/Blobfolio/flaca/releases/download/v${version}/Cargo.lock";
        hash = "sha256-cgb4SNvXOVBiEu79n+4pAbxjXKJV8qFbqjT25V/SujU=";
      };
    in
    runCommand "source-with-lock" { nativeBuildInputs = [ lndir ]; } ''
      mkdir -p $out
      ln -s ${lockFile} $out/Cargo.lock
      lndir -silent ${source} $out
    '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-hiEvb33YJPwGnORp2PHHrDFFAhPDYiMTaDZhN2W61J8=";

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
