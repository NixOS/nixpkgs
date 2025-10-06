{
  lib,
  stdenv,
  fetchFromGitHub,

  makeWrapper,

  chromium,
  python3,
  undetected-chromedriver,
  xorg,

  nixosTests,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      bottle
      waitress
      selenium
      func-timeout
      prometheus-client
      requests
      certifi
      websockets
      packaging
      xvfbwrapper
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flaresolverr";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "FlareSolverr";
    repo = "FlareSolverr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ySYH4Ty6Z1mZWPIhIIX0+78RiozEHJ++3C4kBj7MfU0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace src/utils.py \
      --replace-fail \
        'CHROME_EXE_PATH = None' \
        'CHROME_EXE_PATH = "${lib.getExe chromium}"' \
      --replace-fail \
        'PATCHED_DRIVER_PATH = None' \
        'PATCHED_DRIVER_PATH = "${lib.getExe undetected-chromedriver}"'
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/flaresolverr-${finalAttrs.version}}
    cp -r * $out/share/flaresolverr-${finalAttrs.version}/.

    makeWrapper ${python}/bin/python $out/bin/flaresolverr \
      --add-flags "$out/share/flaresolverr-${finalAttrs.version}/src/flaresolverr.py" \
      --prefix PATH : "${lib.makeBinPath [ xorg.xvfb ]}"
  '';

  passthru = {
    tests.smoke-test = nixosTests.flaresolverr;
  };

  meta = with lib; {
    description = "Proxy server to bypass Cloudflare protection";
    homepage = "https://github.com/FlareSolverr/FlareSolverr";
    changelog = "https://github.com/FlareSolverr/FlareSolverr/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "flaresolverr";
    maintainers = [ ];
    inherit (undetected-chromedriver.meta) platforms;
  };
})
