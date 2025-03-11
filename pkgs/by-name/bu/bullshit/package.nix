{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gawk,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "bullshit";
  version = "0-unstable-2018-05-28";

  src = fetchFromGitHub {
    owner = "fceschmidt";
    repo = "bullshit-arch";
    rev = "d65e4bbbea76bb752842c2c464154a7b417783fa";
    hash = "sha256-sqtQDaWtfhn9XYRsF8lVLHYb+7o9Hf7rLKsX6dw3Sh4=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm555 src/bullshit -t $out/bin
    install -Dm444 src/bullshit_lib $out/share/wordlists/bullshit.txt
    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    patchShebangs $out/bin/bullshit
    substituteInPlace $out/bin/bullshit \
        --replace /usr/lib/bullshit $out/share/wordlists/bullshit.txt \
        --replace awk '${gawk}/bin/awk'
    runHook postFixup
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Nonsense phrase generator";
    mainProgram = "bullshit";
    homepage = "https://github.com/fceschmidt/bullshit-arch";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ krloer ];
    inherit (gawk.meta) platforms;
  };
}
