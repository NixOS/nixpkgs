{
  lib,
  stdenv,
  fetchFromGitea,
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

  src = fetchFromGitea {
    domain = "git.disroot.org";
    owner = "Sir_Walrus";
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
    homepage = "https://git.disroot.org/Sir_Walrus/Flips";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
    mainProgram = "flips";
  };
}
