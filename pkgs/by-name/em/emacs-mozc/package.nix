{
  lib,
  pkg-config,
  python3,
  libxcrypt-legacy,
  glib,
  stdenv,
  writableTmpDirAsHomeHook,
  lndir,
  mozc,
}:
let
  inherit (mozc)
    version
    src
    bazel
    bazelPythonPatch
    ;
  pname = "emacs-mozc";

  nativeBuildInputs = [
    bazel
    lndir
    pkg-config
    python3
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    glib
    libxcrypt-legacy
  ];

  includePath = lib.makeIncludePath buildInputs;
  libraryPath = lib.makeLibraryPath buildInputs;

  bazelArgs = [
    "--config=oss_linux"
    "--config=stable_channel"
    "--config=release_build"
    "--action_env=C_INCLUDE_PATH=${includePath}"
    "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
    "--action_env=LIBRARY_PATH=${libraryPath}"
    "unix/emacs:mozc_emacs_helper"
  ];

  # vendoring: run "bazel vendor" to download all external dependencies,
  # then clean up sandbox-specific symlinks and markers so the output
  # is reproducible (fixed-output derivation).
  vendorDeps = stdenv.mkDerivation (
    lib.fetchers.normalizeHash { } {
      pname = "${pname}-vendor";
      inherit
        src
        version
        nativeBuildInputs
        buildInputs
        ;

      hash = "sha256-/3skENyFujuslRXWg3sm2IFCzqV+zU4vxE0NxEs2vwE=";
      outputHashMode = "recursive";

      strictDeps = true;
      __structuredAttrs = true;

      env.USE_BAZEL_VERSION = bazel.version;

      buildPhase = ''
        runHook preBuild

        cd src

        cat >> MODULE.bazel << EOF
        ${bazelPythonPatch}
        EOF

        bazel vendor --lockfile_mode=update --vendor_dir="$out/vendor_dir" ${lib.escapeShellArgs bazelArgs}
        cp MODULE.bazel.lock "$out"

        echo "removing broken symlinks and markers..."
        find "$out" -type l -lname '/*' -print -delete
        find "$out" -xtype l -print -delete
        rm -vrf "$out"/vendor_dir/*local_python3*

        runHook postBuild
      '';
      dontInstall = true;
      dontFixup = true;
      dontWrapQtApps = true;
    }
  );
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    nativeBuildInputs
    buildInputs
    ;

  strictDeps = true;
  __structuredAttrs = true;

  env.USE_BAZEL_VERSION = bazel.version;

  postPatch = ''
    cd src

    cat >> MODULE.bazel << EOF
    ${bazelPythonPatch}
    EOF

    substituteInPlace config.bzl \
      --replace-fail "/usr/lib/mozc" "${mozc}/lib/mozc" \
      --replace-fail "/usr" "$out"

    # setup vendor dir
    cp -r --no-preserve=mode "${vendorDeps}"/* .
    substituteInPlace \
      vendor_dir/rules_python*/python/private/py_runtime_info.bzl \
      vendor_dir/rules_python*/python/private/py_executable.bzl \
      vendor_dir/rules_python*/python/private/runtime_env_toolchain.bzl \
      --replace-fail "/usr/bin/env python3" "${lib.getExe python3}"
    patchShebangs --build vendor_dir
    for dir in vendor_dir/*/; do
      echo "pin(\"@@$(basename "$dir")\")"
    done > vendor_dir/VENDOR.bazel
  '';

  buildPhase = ''
    runHook preBuild

    bazel build --lockfile_mode=error --vendor_dir=vendor_dir ${lib.escapeShellArgs bazelArgs}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 bazel-bin/unix/emacs/mozc_emacs_helper "$out/bin/mozc_emacs_helper"
    install -Dm444 unix/emacs/mozc.el                     "$out/share/emacs/site-lisp/emacs-mozc/mozc.el"

    runHook postInstall
  '';

  passthru = {
    inherit vendorDeps;
  };
  meta = {
    description = "Japanese input method from Google";
    mainProgram = "mozc_emacs_helper";
    homepage = "https://github.com/google/mozc";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pineapplehunter
    ];
  };
}
