{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  serve,
  xsel,
  nix-update-script,

  configFile ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "0wm-client";
  version = "0-unstable-2026-10-09";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lab0-cc";
    repo = "0WM-Client";
    rev = "31228b74018542d0de70a47f1cc07f2d0dd91c8c";
    hash = "sha256-YxfcXp6KHmiL+kemdCBRY9LfRm9vrniIB/HtlojscHU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postConfigure = ''
    substituteInPlace js/app.mjs \
      --replace-fail \
        'http://ap.local' \
        'http://127.0.0.1:8003'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out

    ${lib.optionalString (configFile != null) ''
      # no other easy way to specify the config file but to replace it
      install -m 600 ${configFile} $out/config.json
    ''}

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe serve} $out/bin/0wm-client \
      --prefix PATH : ${lib.makeBinPath [ xsel ]} \
      --add-flags "--symlinks" \
      --set-default "CLIENT_ADDRESS" "127.0.0.1" \
      --set-default "CLIENT_PORT" "8002" \
      --add-flags '-l "tcp://$CLIENT_ADDRESS:$CLIENT_PORT"' \
      --chdir $out
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

  meta = {
    description = "0WM mobile client frontend";
    homepage = "https://github.com/lab0-cc/0WM-Client";
    mainProgram = "0wm-client";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
