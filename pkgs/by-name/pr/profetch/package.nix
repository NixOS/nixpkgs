{
  stdenv,
  lib,
  fetchFromGitHub,
  gprolog,
}:

stdenv.mkDerivation rec {
  pname = "profetch";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "RustemB";
    repo = "profetch";
    rev = "v${version}";
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

  meta = with lib; {
    description = "System Information Fetcher Written in GNU/Prolog";
    homepage = "https://github.com/RustemB/profetch";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.vel ];
    mainProgram = "profetch";
  };
}
