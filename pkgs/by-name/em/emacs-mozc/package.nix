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
    bazelCommonArgs
    mkVendorDeps
    setupBazelVendor
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

  bazelArgs = bazelCommonArgs ++ [
    "--action_env=C_INCLUDE_PATH=${includePath}"
    "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
    "--action_env=LIBRARY_PATH=${libraryPath}"
    "unix/emacs:mozc_emacs_helper"
  ];

  vendorDeps = mkVendorDeps {
    inherit
      pname
      src
      version
      nativeBuildInputs
      buildInputs
      bazelArgs
      ;
    hash = "sha256-FZiWgzqXa+0HZ/FG+GQUM6TV6DbiB48787Kdny8bmwg=";
  };
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

    ${setupBazelVendor vendorDeps}

    substituteInPlace config.bzl \
      --replace-fail "/usr/lib/mozc" "${mozc}/lib/mozc" \
      --replace-fail "/usr" "$out"
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
    install -Dm444 ../LICENSE "$out/share/licenses/$pname/LICENSE"

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
