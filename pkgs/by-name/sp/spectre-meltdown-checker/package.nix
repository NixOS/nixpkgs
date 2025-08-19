{
  binutils-unwrapped,
  coreutils,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectre-meltdown-checker";
  version = "0.46-unstable-2024-08-04";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
    rev = "34c6095912d115551f69435a55d6e0445932fdf9";
    hash = "sha256-m0f0+AFPrB2fPNd1SkSj6y9PElTdefOdI51Jgfi816w=";
  };

  passthru.updateScript = unstableGitUpdater { };

  prePatch = ''
    substituteInPlace spectre-meltdown-checker.sh \
      --replace-fail /bin/echo ${coreutils}/bin/echo
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 spectre-meltdown-checker.sh $out/bin/spectre-meltdown-checker
    wrapProgram $out/bin/spectre-meltdown-checker \
      --prefix PATH : ${lib.makeBinPath [ binutils-unwrapped ]}

    runHook postInstall
  '';

  meta = {
    description = "Spectre & Meltdown vulnerability/mitigation checker for Linux";
    mainProgram = "spectre-meltdown-checker";
    homepage = "https://github.com/speed47/spectre-meltdown-checker";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.linux;
  };
})
