{
  lib,
  stdenv,
  fetchFromGitHub,
  libdivsufsort,
  pkg-config,

  withGTK3 ? !stdenv.hostPlatform.isDarwin,
  gtk3,
  llvmPackages,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "flips";
  version = "198";

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
    tag = "v${version}";
    hash = "sha256-zYGDcUbtzstk1sTKgX2Mna0rzH7z6Dic+OvjZLI1umI=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional withGTK3 wrapGAppsHook3;

  buildInputs = [
    libdivsufsort
  ]
  ++ lib.optional withGTK3 gtk3
  ++ lib.optional (withGTK3 && stdenv.hostPlatform.isDarwin) llvmPackages.openmp;

  patches = [ ./use-system-libdivsufsort.patch ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "TARGET=${if withGTK3 then "gtk" else "cli"}"
  ];

  installPhase = lib.optionalString (!withGTK3) ''
    runHook preInstall
    install -Dm755 flips -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Patcher for IPS and BPS files";
    homepage = "https://github.com/Alcaro/Flips";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
    mainProgram = "flips";
  };
}
