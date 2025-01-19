{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "0.4.0";
in
stdenv.mkDerivation {
  name = "satysfi-zrbase";
  inherit version;

  src = fetchFromGitHub {
    owner = "zr-tex8r";
    repo = "satysfi-zrbase";
    tag = version;
    hash = "sha256-waqV3IJEeFOoex0vqI8zPogc/t3nDF7gQalm3Gfu0cA=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/satysfi
    cp -r $src/zexn0.satyg $out/share/satysfi
    cp -r $src/zfmt0.satyg $out/share/satysfi
    cp -r $src/zl0.satyg $out/share/satysfi
    cp -r $src/zlist0.satyg $out/share/satysfi
    cp -r $src/zlog0.satyg $out/share/satysfi
    cp -r $src/zmtdoc0.satyh $out/share/satysfi
    cp -r $src/znum0.satyg $out/share/satysfi
    cp -r $src/zp0.satyg $out/share/satysfi
    cp -r $src/zrandom0.satyg $out/share/satysfi
    cp -r $src/zrbase0.satyg $out/share/satysfi
    cp -r $src/zresult0.satyg $out/share/satysfi
    cp -r $src/zs0.satyg $out/share/satysfi
    runHook postInstall
  '';

  meta = {
    description = "A collection of packages to make programming in SATySFi more comfortable";
    homepage = "https://github.com/zr-tex8r/satysfi-zrbase";
    changelog = "https://github.com/zr-tex8r/satysfi-zrbase/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
