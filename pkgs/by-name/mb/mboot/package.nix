{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "mboot";
  version = "0-unstable-2022-11-10";

  src = fetchFromGitHub {
    owner = "osm0sis";
    repo = "mboot";
    rev = "39f59a4f1b6a754c8953172fb80cb2ea1221ed20";
    hash = "sha256-xpVokOb4cenrrlORNIl58NuOSnaVyCIxRbyunRpix1U=";
  };

  strictDeps = true;

  # Unstream has an install target, but installs mboot as `$out/bin`
  # instead of `$out/bin/mboot`
  installPhase = ''
    runHook preInstall
    install -Dm555 mboot -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/osm0sis/mboot";
    description = "Tool to pack and unpack Intel Android boot files";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "mboot";
  };
}
