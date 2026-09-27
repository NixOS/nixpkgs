{
  stdenv,
  lib,
  fetchFromGitHub,
  gprolog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "profetch";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "RustemB";
    repo = "profetch";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JsjpPUXMN0jytRS4yzSjrseqHiEQ+YinklG+tIIy+Zo=";
  };

  nativeBuildInputs = [ gprolog ];

  buildPhase = ''
    runHook preBuild
    gplc profetch.pl --no-top-level --no-debugger    \
                     --no-fd-lib    --no-fd-lib-warn \
                     --min-size -o profetch
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin profetch
    runHook postInstall
  '';

  meta = {
    description = "System Information Fetcher Written in GNU/Prolog";
    homepage = "https://github.com/RustemB/profetch";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.vel ];
    mainProgram = "profetch";
  };
})
