{
  pname,
  version,
  src,
  nativeBuildInputs,
  passthru,
  meta,
  stdenv,
  config,
  writeText,
  autoPatchelfHook,
  patchelfUnstable,
  alsa-lib,
}:

let
  policies = {
    DisableAppUpdate = true;
  }
  // config.thunderbird.policies or { };

  policiesJson = writeText "thunderbird-policies.json" (builtins.toJSON { inherit policies; });
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    ;

  nativeBuildInputs = nativeBuildInputs ++ [
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = [
    alsa-lib
  ];

  # Thunderbird uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];

  postPatch = ''
    # Don't download updates from Mozilla directly
    echo 'pref("app.update.auto", "false");' >> defaults/pref/channel-prefs.js
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$prefix/usr/lib/thunderbird-bin-${version}"
    cp -r * "$prefix/usr/lib/thunderbird-bin-${version}"

    mkdir -p "$out/bin"
    ln -s "$prefix/usr/lib/thunderbird-bin-${version}/thunderbird" "$out/bin/"

    # wrapThunderbird expects "$out/lib" instead of "$out/usr/lib"
    ln -s "$out/usr/lib" "$out/lib"

    gappsWrapperArgs+=(--argv0 "$out/bin/.thunderbird-wrapped")

    # See: https://github.com/mozilla/policy-templates/blob/master/README.md
    mkdir -p "$out/lib/thunderbird-bin-${version}/distribution";
    ln -s ${policiesJson} "$out/lib/thunderbird-bin-${version}/distribution/policies.json";

    runHook postInstall
  '';

  inherit passthru meta;
}
