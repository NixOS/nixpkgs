{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  ncurses,
  notmuch,
  scdoc,
  python3Packages,
  w3m,
  dante,
  gawk,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.20.0";

  src = fetchFromSourcehut {
    owner = "~rjarry";
    repo = "aerc";
    rev = version;
    hash = "sha256-0ZSmmmj5PpSORL0s0SSNoZGzct9Ps8j0ILAUCpJOOBw=";
  };

  proxyVendor = true;
  vendorHash = "sha256-WowRlAzyrfZi27JzskIDberiYt9PQkuS6H3hKqUP9qo=";

  nativeBuildInputs = [
    scdoc
    python3Packages.wrapPython
  ];

  patches = [ ./runtime-libexec.patch ];

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
    notmuch
    gawk
  ];

  installPhase = ''
    runHook preInstall

    make $makeFlags GOFLAGS="$GOFLAGS -tags=notmuch" install

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
    changelog = "https://git.sr.ht/~rjarry/aerc/tree/${version}/item/CHANGELOG.md";
    maintainers = [ ];
    mainProgram = "aerc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
