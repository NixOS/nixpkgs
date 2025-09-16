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
      func-timeout
      prometheus-client
      selenium
      waitress
      xvfbwrapper

      # For `undetected_chromedriver`
      looseversion
      requests
      websockets
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flaresolverr";
  version = "3.3.25";

  src = fetchFromGitHub {
    owner = "FlareSolverr";
    repo = "FlareSolverr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AGRqJOIIePaJH0j0eyMFJ6Kddul3yXF6uw6dPMnskmY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace src/undetected_chromedriver/patcher.py \
      --replace-fail \
        "from distutils.version import LooseVersion" \
        "from looseversion import LooseVersion"

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
    maintainers = with maintainers; [ ];
    inherit (undetected-chromedriver.meta) platforms;
  };
})
