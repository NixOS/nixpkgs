{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3,
  _0wm-server,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "0wm-ap-mock";
  version = "0-unstable-2026-02-26";

  src = fetchFromGitHub {
    owner = "lab0-cc";
    repo = "0WM-AP-Mock";
    rev = "4a61e6cfdd103a69bc861899eae58336ab572159";
    hash = "sha256-VVc/ZI+F8EGzKj3JCaKr1bHxROEUBE0hiZ2mnvemSlg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${python3.interpreter} $out/bin/0wm-ap-mock \
      --set-default "AP_MOCK_ADDRESS" "127.0.0.1" \
      --set-default "AP_MOCK_PORT" "8003" \
      --add-flags "server.py" \
      --add-flags '$AP_MOCK_PORT' \
      --chdir $out
  '';

  meta = {
    description = "Mock Zyxel AP server";
    homepage = "https://github.com/lab0-cc/0WM-AP-Mock";
    mainProgram = "0wm-ap-mock";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    inherit (_0wm-server)
      maintainers
      teams
      ;
  };
})
