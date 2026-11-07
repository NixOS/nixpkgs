{
  # Package metadata
  pname,
  source,
  meta,
  binaryName,
  desktopName,
  hostVersion,
  passthru,
  moduleSrcs,
  # Package utilities
  disableBreakingUpdates,
  stageModules,
  # Feature flags (cross-platform)
  withOpenASAR ? false,
  withVencord ? false,
  withEquicord ? false,
  withMoonlight ? false,
  # Disabling this would normally break Discord.
  # The intended use-case is when SKIP_HOST_UPDATE and SKIP_MODULE_UPDATE are
  # enabled via other means, such as a declaratively linked settings.json
  disableUpdates ? true,
  # Package arguments
  commandLineArgs ? "",
  # Miscellaneous
  lib,
  stdenv,
  makeWrapper,
  brotli,
  jq,
  python3,
  writeScript,
  fetchurl,
  openasar,
  vencord,
  equicord,
  moonlight,
}:

let
  inherit (source) version;

  src = fetchurl { inherit (source.distro) url hash; };

  fixDistroSymlinks = writeScript "discord-fix-distro-symlinks.py" ''
    #!${python3.interpreter}
    import pathlib
    import sys
    import tarfile

    with tarfile.open(sys.argv[1]) as tar:
        for member in tar:
            if not member.issym():
                continue
            parts = pathlib.PurePosixPath(member.name).parts[1:]
            if not parts:
                continue
            path = pathlib.Path(sys.argv[2], *parts)
            path.unlink(missing_ok=True)
            path.symlink_to(member.linkname)
  '';
in
stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    meta
    passthru
    disableBreakingUpdates
    stageModules
    ;

  nativeBuildInputs = [
    brotli
    jq
    makeWrapper
  ];

  sourceRoot = ".";

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications

    extractDistro() {
      local src="$1"
      local dest="$2"
      local tarball
      tarball=$(mktemp)
      brotli -d < "$src" > "$tarball"
      tar xf "$tarball" --strip-components=1 -C "$dest"

      # Discord's distro tarballs store symlinks with mode 000, which makes
      # them unreadable on Darwin. Recreate them with normal permissions.
      ${fixDistroSymlinks} "$tarball" "$dest"

      tar xfO "$tarball" delta_manifest.json

      rm "$tarball"
    }

    host=$(mktemp)

    extractDistro "$src" "$out/Applications" \
      | jq '{ host_version: ${builtins.toJSON hostVersion}, distro_manifest: ., install_state: "Installed" }' \
      > "$host"

    modules=$(mktemp)

    ${lib.concatMapAttrsStringSep "\n" (
      name:
      { src, version }:
      let
        module_version = {
          inherit version;
          module = {
            inherit name;
            host_version = hostVersion;
          };
        };
      in
      ''
        mkdir -p "$out/share/${pname}/modules/${name}-${toString version}/${name}"
        extractDistro ${src} "$out/share/${pname}/modules/${name}-${toString version}/${name}" \
          | jq '{ module_version: ${builtins.toJSON module_version}, distro_manifest: ., install_state: "Installed" }' \
          >> "$modules"
      ''
    ) moduleSrcs}

    # The updater creates pending even when module updates are disabled
    mkdir -p "$out/share/${pname}/modules/pending"

    jq --slurpfile modules "$modules" '[. + { $modules }]' "$host" > "$out/share/${pname}/deltas.json"
    rm "$host" "$modules"

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/${desktopName}.app/Contents/MacOS/${binaryName}" "$out/bin/${binaryName}" \
      ${lib.strings.optionalString disableUpdates "--run \"${lib.getExe finalAttrs.disableBreakingUpdates} &\""} \
      --run "${finalAttrs.stageModules} \"$out/share/${pname}/modules\" \"$out/share/${pname}/deltas.json\"" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  postInstall =
    lib.strings.optionalString withOpenASAR ''
      cp -f ${openasar} "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
    ''
    + lib.strings.optionalString withVencord ''
      mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
      mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
      echo '{"name":"discord","main":"index.js"}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
      echo 'require("${vencord}/patcher.js")' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js"
    ''
    + lib.strings.optionalString withEquicord ''
      mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
      mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
      echo '{"name":"discord","main":"index.js"}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
      echo 'require("${equicord}/desktop/patcher.js")' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js"
    ''
    + lib.strings.optionalString withMoonlight ''
      mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
      mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
      echo '{"name":"discord","main":"injector.js","private": true}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
      echo 'require("${moonlight}/injector.js").inject(require("path").join(__dirname, "../_app.asar"));' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/injector.js"
    '';
})
