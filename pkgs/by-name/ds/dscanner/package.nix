{ stdenv, lib, fetchFromGitHub, gnumake, ldc }:
stdenv.mkDerivation (finalAttrs: {
  pname = "dscanner";
  version = "0.16.0-beta.4";

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "D-Scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5rct/HgQfmY79divQNxriKwSW+7N2poWHnV9NbDyJo8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ gnumake ldc];

  preBuild = ''
    mkdir -p bin
    echo "${finalAttrs.version}" > bin/githash.txt
    export DC=ldc2
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/dscanner -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "D-Scanner is a tool for analyzing D source code";
    homepage = "https://github.com/dlang-community/D-Scanner";
    license = lib.licenses.boost;
    mainProgram = "dscanner";
    maintainers = with lib.maintainers; [ imrying ];
  };
})
