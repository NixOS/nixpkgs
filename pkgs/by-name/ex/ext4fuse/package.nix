{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
  macfuse-stubs,
  pkg-config,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ext4fuse";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "gerard";
    repo = "ext4fuse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bsFo+aaeNceSme9WBUVg4zpE4DzlmLHv+esQIAlTGGU=";
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [ (if stdenv.isDarwin then macfuse-stubs else fuse) ];

  installPhase = ''
    runHook preInstall

    install -Dm555 ext4fuse $out/bin/ext4fuse

    runHook postInstall
  '';

  meta = with lib; {
    description = "EXT4 implementation for FUSE";
    mainProgram = "ext4fuse";
    homepage = "https://github.com/gerard/ext4fuse";
    maintainers = with maintainers; [ felixalbrigtsen ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
})
