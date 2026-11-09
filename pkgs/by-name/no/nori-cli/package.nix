{
  lib,
  stdenvNoCC,
  fetchurl,
  gnutar,
  gzip,
  buildFHSEnv,
  appimageTools,
  alsa-lib,
  webkitgtk_4_1,
  cacert,
  nix-update-script,
}:

let
  pname = "nori-cli";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/norifm/nori/releases/download/v${version}/nori-cli-${version}-linux-x86_64.tar.gz";
    hash = "sha256-lc7VlWSjBM/EHO2HcAkkreBaJFvJwy3ymhDdxbUt+kk=";
  };

  unpacked = stdenvNoCC.mkDerivation {
    pname = "nori-cli-unpacked";
    inherit version src;

    dontUnpack = true;
    nativeBuildInputs = [
      gnutar
      gzip
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$TMPDIR/nori-cli" "$out/bin"
      tar -xzf "$src" -C "$TMPDIR/nori-cli"

      binary="$(find "$TMPDIR/nori-cli" -type f -name nori-cli -print -quit)"
      test -n "$binary"
      install -m755 "$binary" "$out/bin/nori-cli"

      runHook postInstall
    '';
  };

  fhsDefaults = appimageTools.defaultFhsEnvArgs;
in
buildFHSEnv (
  fhsDefaults
  // {
    inherit pname version;

    executableName = "nori-cli";
    runScript = "${unpacked}/bin/nori-cli";

    # The CLI uses CPAL/ALSA for audio and WebKitGTK for provider sign-in.
    targetPkgs =
      pkgs:
      fhsDefaults.targetPkgs pkgs
      ++ ([
        alsa-lib
        webkitgtk_4_1
      ]);

    profile = ''
      export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    '';

    passthru.updateScript = nix-update-script { };

    meta = {
      maintainers = with lib.maintainers; [ juanqp07 ];
      description = "Nori terminal music player for Navidrome, Subsonic and YouTube Music";
      homepage = "https://norifm.com/";
      changelog = "https://github.com/norifm/nori/releases/tag/v${version}";
      license = lib.licenses.agpl3Plus;
      mainProgram = "nori-cli";
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
)
