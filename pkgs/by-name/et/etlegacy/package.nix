{
  lib,
  stdenv,
  symlinkJoin,
  etlegacy-assets,
  etlegacy-unwrapped,
  makeBinaryWrapper,
}:

let
  binarySuffix =
    if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else if stdenv.hostPlatform.isi686 then
      "i386"
    else
      throw "Unsupported architecture: ${stdenv.hostPlatform.system}";
in
symlinkJoin {
  pname = "etlegacy";
  version = "2.84.0";

  paths = [
    etlegacy-assets
    etlegacy-unwrapped
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postBuild = ''
    wrapProgram $out/bin/etl.* \
      --add-flags "+set fs_basepath ${placeholder "out"}/lib/etlegacy"
    wrapProgram $out/bin/etlded.* \
      --add-flags "+set fs_basepath ${placeholder "out"}/lib/etlegacy"
  '';

  meta = {
    description = "ET: Legacy is an open source project based on the code of Wolfenstein: Enemy Territory which was released in 2010 under the terms of the GPLv3 license";
    homepage = "https://etlegacy.com";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-nc-sa-30
    ];
    longDescription = ''
      ET: Legacy, an open source project fully compatible client and server
      for the popular online FPS game Wolfenstein: Enemy Territory - whose
      gameplay is still considered unmatched by many, despite its great age.
    '';
    mainProgram = "etl." + binarySuffix;
    maintainers = with lib.maintainers; [
      ashleyghooper
    ];
    platforms = lib.platforms.linux;
  };
}
