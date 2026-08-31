{
  lib,
  stdenv,
  fetchFromGitHub,
  deno,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bewcloud";
  version = "1.4.11";

  src = fetchFromGitHub {
    owner = "bewcloud";
    repo = "bewcloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xh4XEO5kK1y8AdDE6jCW+j0Hj1PlxOlEN+E/IBDHDX8=";
  };

  nativeBuildInputs = [
    makeWrapper
    deno
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/bewcloud}
    cp -r . $out/share/bewcloud

    makeWrapper ${deno}/bin/deno $out/bin/bewcloud \
      --add-flags "run --allow-net --allow-read --allow-write --allow-env $out/share/bewcloud/main.ts"

    cp $out/share/bewcloud/.env.sample $out/share/bewcloud/.env

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/bewcloud/Makefile \
      --replace-fail "deno run" "${deno}/bin/deno run"
  '';

  meta = {
    description = "Simpler alternative to Nextcloud built with Fresh";
    homepage = "https://bewcloud.com";
    changelog = "https://github.com/Kagamma/tparted/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "bewcloud";
  };
})
