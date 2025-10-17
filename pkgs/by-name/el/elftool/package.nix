{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "elftool";
  version = "0-unstable-2022-11-10";

  src = fetchFromGitHub {
    owner = "osm0sis";
    repo = "elftool";
    rev = "363653ee89d7b4e1cd5e1f2c878d71acd75fc072";
    hash = "sha256-nMJhMzzvXtrezZbKdsBq24/El2n7ubiBd5XEYFg3C00=";
  };

  strictDeps = true;

  # Needed to fix `collect2: error: ld returned 1 exit status`
  env.NIX_LDFLAGS = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";

  makeFlags = [ "CC=c++" ];

  installPhase = ''
    runHook preInstall
    install -Dm555 elftool -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/osm0sis/elftool";
    description = "Program for packing and unpacking boot images from Sony mobile devices";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "elftool";
  };
}
