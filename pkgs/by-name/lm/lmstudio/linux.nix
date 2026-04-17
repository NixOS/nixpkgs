{
  appimageTools,
  fetchurl,
  version,
  url,
  hash,
  pname,
  meta,
  stdenv,
  lib,
  passthru,
  graphicsmagick,
  bun,
  python3,
}:
let
  src = fetchurl { inherit url hash; };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit
    meta
    pname
    version
    src
    passthru
    ;

  nativeBuildInputs = [ graphicsmagick bun python3 ];

  extraPkgs = pkgs: [ pkgs.ocl-icd ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications

    # setup icons (see https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=lmstudio#n55 for how Arch solved this; approach adapted to here)
    src_icon="${appimageContents}/usr/share/icons/hicolor/0x0/apps/lm-studio.png"
    sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256")
    for size in "''${sizes[@]}"; do
      install -dm755 "$out/share/icons/hicolor/$size/apps"
      gm convert "$src_icon" -resize "$size" "$out/share/icons/hicolor/$size/apps/lm-studio.png"
    done

    install -m 444 -D ${appimageContents}/lm-studio.desktop -t $out/share/applications

    # Rename the main executable from lmstudio to lm-studio
    mv $out/bin/lmstudio $out/bin/lm-studio

    substituteInPlace $out/share/applications/lm-studio.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lm-studio'

    # lms cli tool — extract JS from bun binary, apply foreground patches, recompile
    local lmsBin="${appimageContents}/resources/app/.webpack/lms"
    python3 -c "
import struct, sys
with open('$lmsBin', 'rb') as f:
    f.seek(0, 2)
    size = f.tell()
    # Find the start of the JS source (shebang line)
    f.seek(0)
    data = f.read()
    start = data.find(b'#!/usr/bin/env node')
    # Find the end of JS source (first null byte after start)
    end = data.index(b'\x00', start)
    js = data[start:end]
    with open('lms-source.js', 'wb') as out:
        out.write(js)
    print(f'Extracted {len(js)} bytes of JS from offset {start}', file=sys.stderr)
"

    # Apply foreground patches to the extracted JS source
    # Patch 1: Add foreground to findOrStartLlmster destructuring
    substituteInPlace lms-source.js \
      --replace-fail \
        'const { installLlmster, maxAttempts = 60, pollIntervalMs = 1000 } = options;' \
        'const { installLlmster, maxAttempts = 60, pollIntervalMs = 1000, foreground = false } = options;'

    # Patch 2: Capture child from wakeUpServiceFromLocation and block in foreground mode
    substituteInPlace lms-source.js \
      --replace-fail \
        'wakeUpServiceFromLocation(logger, installLocation, isDaemon);' \
        'const child = wakeUpServiceFromLocation(logger, installLocation, isDaemon, foreground);'

    substituteInPlace lms-source.js \
      --replace-fail \
        'logger.debug(`LM Studio daemon became available at port ''${serverStatus2}`);
      logger.debug(`package=''${serverStatus2.package}, version=''${serverStatus2.version}`);
      return serverStatus2;' \
        'logger.debug(`LM Studio daemon became available at port ''${serverStatus2}`);
      logger.debug(`package=''${serverStatus2.package}, version=''${serverStatus2.version}`);
      if (foreground && child !== null) { await new Promise((resolve3, reject) => { child.on("exit", (code, signal) => { if (code === 0 || signal === "SIGTERM" || signal === "SIGINT") { resolve3(); } else { reject(new Error(`LM Studio daemon exited with code ''${code}, signal ''${signal}`)); } }); child.on("error", reject); }); }
      return serverStatus2;'

    # Patch 3: Add foreground parameter to wakeUpServiceFromLocation
    substituteInPlace lms-source.js \
      --replace-fail \
        'function wakeUpServiceFromLocation(logger, installLocation, isDaemon) {' \
        'function wakeUpServiceFromLocation(logger, installLocation, isDaemon, foreground = false) {'

    # Patch 4: Add foreground spawn mode before existing spawn
    substituteInPlace lms-source.js \
      --replace-fail \
        'try {
    if (false) {} else {
      const child = spawn(path, args, {
        cwd: cwd3,
        detached: true,
        stdio: "ignore",
        env: env3
      });
      child.unref();
      logger.debug("LM Studio daemon process spawned.");
    }
  } catch (e) {
    logger.debug("Failed to launch LM Studio daemon process:", e);
  }
}' \
        'try {
    if (foreground && process.platform !== "win32") {
      const child = spawn(path, args, { cwd: cwd3, detached: false, stdio: "inherit", env: env3 });
      logger.debug(`LM Studio daemon process spawned in foreground (PID ''${child.pid}).`);
      return child;
    }
    if (false) {} else {
      const child = spawn(path, args, {
        cwd: cwd3,
        detached: true,
        stdio: "ignore",
        env: env3
      });
      child.unref();
      logger.debug("LM Studio daemon process spawned.");
    }
  } catch (e) {
    logger.debug("Failed to launch LM Studio daemon process:", e);
  }
  return null;
}'

    # Patch 5: Add --foreground CLI option to server start command
    substituteInPlace lms-source.js \
      --replace-fail \
        'required if you are developing a web application.
    `);' \
        'required if you are developing a web application.
    `).option("--foreground", text$1`
      Run the daemon in the foreground instead of detaching it. The process will block until the
      daemon exits. Useful for process supervisors (systemd, launchd, etc.) that need to own the
      daemon lifecycle.
    `);'

    # Patch 6: Destructure foreground in server start action and pass to createClient
    substituteInPlace lms-source.js \
      --replace-fail \
        'const { port, bind, cors = false, ...logArgs } = options;' \
        'const { port, bind, cors = false, foreground = false, ...logArgs } = options;'

    # Patch 7: Pass foreground to createClient
    # Need to find the right createClient call - the one in the server start action
    # The compiled source uses args2 as the parameter name in createClient
    substituteInPlace lms-source.js \
      --replace-fail \
        'await createClient(logger2, logArgs), true);' \
        'await createClient(logger2, { ...logArgs, foreground }), true);'

    # Patch 8: Forward foreground from createClient args to findOrStartLlmster
    substituteInPlace lms-source.js \
      --replace-fail \
        'const serverStatus = await findOrStartLlmster({
      logger: logger2
    });' \
        'const serverStatus = await findOrStartLlmster({
      logger: logger2,
      foreground: args2.foreground
    });'

    # Recompile with bun
    bun build --compile lms-source.js --outfile lms-patched

    install -m 755 lms-patched $out/bin/lms

    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/bin/lms
  '';
}
