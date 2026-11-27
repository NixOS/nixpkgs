{
  lib,
  stdenv,
  fetchFromGitHub,
  jq,
  makeBinaryWrapper,
  openssl,
  sbcl,
  sqlite,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  sbclWithPkgs = sbcl.withPackages (ps: [
    ps.alexandria
    ps.bordeaux-threads
    ps.chipz
    ps.cl-base64
    ps.cl-jpeg
    ps.cl-ppcre
    ps.cl_plus_ssl
    ps.clack
    ps.clack-handler-hunchentoot
    ps.dexador
    ps.flexi-streams
    ps.hunchentoot
    ps.ironclad
    ps.quri
    ps.salza2
    ps.shasht
    ps.sqlite
    ps.usocket
    ps.websocket-driver
  ]);

  cellsSrc = fetchFromGitHub {
    owner = "nodecode-ai";
    repo = "cells";
    rev = "37366ad05d92bea28f95eac9f2778fed532adab2";
    hash = "sha256-fz0PNwwho3XHvfVPRFsEqSKrPOsutK0CMuo3ZSYqv+Y=";
  };

  runtimeLibPath = lib.makeLibraryPath [
    openssl
    sqlite
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nodecode";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "nodecode-ai";
    repo = "nodecode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HQoMUZns7DDiOHSx1MHN0664/Xet8oa4KpNYDFDEwKQ=";
  };

  nativeBuildInputs = [
    jq
    makeBinaryWrapper
    sbclWithPkgs
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  __structuredAttrs = true;
  strictDeps = true;

  # SBCL appends its Lisp core to the end of the executable; stripping or
  # rewriting ELF sections corrupts the core offset trailer.
  dontStrip = true;
  dontPatchELF = true;

  postPatch = ''
    expected_cells_rev=$(jq -r '.commit' cells/bundle.json)
    if [ "$expected_cells_rev" != "${cellsSrc.rev}" ]; then
      echo "cellsSrc.rev (${cellsSrc.rev}) does not match cells/bundle.json ($expected_cells_rev)" >&2
      exit 1
    fi

    jq -r '.cells | to_entries[] | "\(.key)\t\(.value)"' cells/bundle.json | \
      while IFS=$'\t' read -r local_path hub_path; do
        mkdir -p "cells/$local_path"
        cp -r --no-preserve=mode "${cellsSrc}/$hub_path"/. "cells/$local_path/"
      done
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    substituteInPlace src/lib/openssl.lisp \
      --replace-fail "/opt/homebrew/opt/openssl@3/lib/libcrypto.3.dylib" "${lib.getLib openssl}/lib/libcrypto.3.dylib" \
      --replace-fail "/opt/homebrew/opt/openssl@3/lib/libssl.3.dylib" "${lib.getLib openssl}/lib/libssl.3.dylib"
  '';

  buildPhase = ''
    runHook preBuild

    export HOME="$TMPDIR"
    export XDG_CACHE_HOME="$TMPDIR/.cache"
    export LD_LIBRARY_PATH="${runtimeLibPath}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    sbcl --dynamic-space-size 4096 --control-stack-size 8MB --noinform --non-interactive \
      --eval '(load (sb-ext:posix-getenv "ASDF"))' \
      --eval '(push (truename ".") asdf:*central-registry*)' \
      --eval '(push (truename "cells/context/") asdf:*central-registry*)' \
      --eval '(defmethod asdf:perform ((o asdf:image-op) (s (eql (asdf:find-system "nodecode/bin"))))
                (let ((output (asdf:output-file o s)))
                  (setf uiop:*image-entry-point*
                        (uiop:ensure-function (asdf/system:component-entry-point s)))
                  (uiop:dump-image output
                                   :executable t
                                   :compression #+sb-core-compression t #-sb-core-compression nil)))' \
      --eval '(asdf:make :nodecode/bin :force (list "nodecode/bin"))'

    test -s ./nodecode && test -x ./nodecode

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      $CC -O2 -Wall -o nodecode-launcher tools/build/launcher.c
    ''}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec/nodecode/src" "$out/bin"
    install -Dm755 nodecode "$out/libexec/nodecode/nodecode"
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      install -Dm755 nodecode-launcher "$out/libexec/nodecode/nodecode-launcher"
    ''}

    cp -r src "$out/libexec/nodecode/src/src"
    cp -r cells "$out/libexec/nodecode/src/cells"
    cp nodecode.asd "$out/libexec/nodecode/src/nodecode.asd"
    find "$out/libexec/nodecode/src/cells" -type d -name test -prune -exec rm -rf {} +

    makeWrapper "$out/libexec/nodecode/nodecode" "$out/bin/nodecode" \
      --prefix ${
        if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"
      } : "${runtimeLibPath}"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  # Verify version output and that all shipped cells compile and load cleanly
  # into a writable user cache when the binary and sources live in the read-only Nix store.
  installCheckPhase = ''
    runHook preInstallCheck

    cell_home=$(mktemp -d)
    mkdir -p "$cell_home/.nodecode/cells"
    find "$out/libexec/nodecode/src/cells" -name '*.asd' -not -path '*/template/*' -not -path '*/test/*' | while read -r asd; do
      ln -s "$(dirname "$asd")" "$cell_home/.nodecode/cells/$(basename "$asd" .asd)"
    done
    score=$(printf '%s' '(let* ((cells (nodecode.kernel::cells))
                                 (failed (remove-if (lambda (c) (eq (nodecode.kernel::cell-state c) :loaded)) cells)))
                            (if (and (plusp (length cells)) (null failed)) 1 0))' \
      | HOME="$cell_home" NODECODE_HOME="$cell_home/.nodecode" \
        XDG_CACHE_HOME="$cell_home/.cache" XDG_DATA_HOME="$cell_home/.local/share" \
        XDG_CONFIG_HOME="$cell_home/.config" \
        "$out/bin/nodecode" trial | sed -n 's/^nodecode-trial-score //p')
    test "$score" = "1"
    rm -rf "$cell_home"

    runHook postInstallCheck
  '';

  meta = {
    description = "Self-modifying coding agent organism written in Common Lisp";
    homepage = "https://nodecode.ai";
    changelog = "https://github.com/nodecode-ai/nodecode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ThomShark ];
    mainProgram = "nodecode";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
