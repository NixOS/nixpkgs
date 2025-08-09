{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  ncurses,
  withNotmuch ? true,
  notmuch,
  scdoc,
  python3Packages,
  w3m,
  dante,
  gawk,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "aerc";
  version = "0.20.1";

  src = fetchFromSourcehut {
    owner = "~rjarry";
    repo = "aerc";
    rev = finalAttrs.version;
    hash = "sha256-IBTM3Ersm8yUCgiBLX8ozuvMEbfmY6eW5xvJD20UgRA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-O1j0J6vCE6rap5/fOTxlUpXAG5mgZf8CfNOB4VOBxms=";

  nativeBuildInputs = [
    scdoc
    python3Packages.wrapPython
  ];

  patches = [
    ./runtime-libexec.patch

    # TODO remove these with the next release
    # they resolve a path injection vulnerability when saving attachments (CVE-2025-49466)
    ./basename-temp-file.patch
    ./basename-temp-file-fixup.patch
  ];

  postPatch = ''
    substituteAllInPlace config/aerc.conf
    substituteAllInPlace config/config.go
    substituteAllInPlace doc/aerc-config.5.scd
    substituteAllInPlace doc/aerc-templates.7.scd

    # Prevent buildGoModule from trying to build this
    rm contrib/linters.go
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  pythonPath = [ python3Packages.vobject ];

  buildInputs = [
    python3Packages.python
    gawk
  ]
  ++ lib.optional withNotmuch notmuch;

  installPhase = ''
    runHook preInstall

    make $makeFlags GOFLAGS="$GOFLAGS${lib.optionalString withNotmuch " -tags=notmuch"}" install

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/aerc \
      --prefix PATH : ${lib.makeBinPath [ ncurses ]}
    wrapProgram $out/libexec/aerc/filters/html \
      --prefix PATH : ${
        lib.makeBinPath [
          w3m
          dante
        ]
      }
    wrapProgram $out/libexec/aerc/filters/html-unsafe \
      --prefix PATH : ${
        lib.makeBinPath [
          w3m
          dante
        ]
      }
    patchShebangs $out/libexec/aerc/filters
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Email client for your terminal";
    homepage = "https://aerc-mail.org/";
    changelog = "https://git.sr.ht/~rjarry/aerc/tree/${finalAttrs.version}/item/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      defelo
      sikmir
    ];
    mainProgram = "aerc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
