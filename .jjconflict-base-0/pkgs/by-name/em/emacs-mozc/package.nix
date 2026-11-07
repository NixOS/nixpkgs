{
  lib,
  python3,
  stdenv,
  writableTmpDirAsHomeHook,
  mozc,
}:
let
  inherit (mozc)
    version
    src
    bazel
    bazelCommonArgs
    vendorDeps
    setupBazelVendor
    ;
  pname = "emacs-mozc";

  nativeBuildInputs = [
    bazel
    python3
    writableTmpDirAsHomeHook
  ];

  bazelArgs = bazelCommonArgs ++ [
    "unix/emacs:mozc_emacs_helper"
  ];
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    nativeBuildInputs
    ;

  strictDeps = true;
  __structuredAttrs = true;

  env.USE_BAZEL_VERSION = bazel.version;
  # Work around Bazel's username lookup with sandbox=false and auto-allocate-uids=true.
  env.USER = "nixbld";

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
