{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "binternet";
  version = "0-unstable-2026-09-28";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Ahwxorg";
    repo = "Binternet";
    rev = "9bb70ef26c8b79a315e77b79bfd346433d55cbb6";
    hash = "sha256-QYf1iNqZhLGRNt5riMs6U8O7kjsAfL1FZDKj+9u2wPA=";
  };

  # PHP application, no build step
  dontBuild = true;

  postInstall = ''
    mkdir -p $out/share/binternet
    cp -r . $out/share/binternet/
  '';

  meta = {
    description = "Custom Pinterest frontend";
    longDescription = ''
      Personalized alternative frontend for Pinterest written in PHP,
      offering a different way to browse and view pins.
    '';
    homepage = "https://github.com/Ahwxorg/Binternet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
})
