{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  coreutils,
  binutils-unwrapped,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spectre-meltdown-checker";
  version = "0.46";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M4ngdtp2esZ+CSqZAiAeOnKtaK8Ra+TmQfMsr5q5gkg=";
  };

  prePatch = ''
    substituteInPlace spectre-meltdown-checker.sh \
      --replace /bin/echo ${coreutils}/bin/echo
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
