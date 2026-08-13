{
  binutils-unwrapped,
  coreutils,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  stdenv,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectre-meltdown-checker";
  version = "26.36.0602723";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UPpArgFbz2nce63fS6AScitHeL8/XlA0aInyeRxN9ZM=";
  };

  passthru.updateScript = gitUpdater { };

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
    changelog = "https://github.com/speed47/spectre-meltdown-checker/releases/tag/${finalAttrs.src.tag}";
    description = "Spectre & Meltdown vulnerability/mitigation checker for Linux";
    mainProgram = "spectre-meltdown-checker";
    homepage = "https://github.com/speed47/spectre-meltdown-checker";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.linux;
  };
})
