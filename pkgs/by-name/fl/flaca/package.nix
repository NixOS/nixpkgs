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
  version = "3.1.6";

  src =
    let
      source = fetchFromGitHub {
        owner = "Blobfolio";
        repo = pname;
        rev = "v${version}";
        hash = "sha256-mNCb9d7/nRWSkiir2bYkslw/F2GmjvE0cPi7HhzEN68=";
      };
      lockFile = fetchurl {
        url = "https://github.com/Blobfolio/flaca/releases/download/v${version}/Cargo.lock";
        hash = "sha256-tyxTgYEGROCtoiKPX57pF32UcfpDCuMdFSttZu++ju8=";
      };
    in
    runCommand "source-with-lock" { nativeBuildInputs = [ lndir ]; } ''
      mkdir -p $out
      ln -s ${lockFile} $out/Cargo.lock
      lndir -silent ${source} $out
    '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  cargoHash = "sha256-YYNWCJT5ZT36v4u4P3gtW/osor6eIvR8leqlQHHZYMk=";

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
