{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
  lzfse,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "img4lib";
  version = "0-unstable-2021-11-28";

  src = fetchFromGitHub {
    owner = "xerub";
    repo = "img4lib";
    rev = "69772c72f3c08f021ec9fa4c386f2b3df60a38b7";
    hash = "sha256-xCWovBJ9cxT17u1uo+aUQnxDoYFQXYy9Qer0mD45aOU=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    lzfse
    openssl
  ];

  installPhase = "
    runHook preInstall

    install -Dm755 img4 $out/bin/img4

    runHook postInstall
  ";

  strictDeps = true;

  meta = {
    description = "Library and tool for parsing, manipulating, and patching Apple .img4 container files";
    homepage = "https://github.com/xerub/img4lib";
    # No licensing information available
    # https://github.com/xerub/img4lib/issues/14
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "img4";
  };
})
