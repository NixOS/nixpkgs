{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  fetchpatch,
  ncurses,
  notmuch,
  scdoc,
  python3Packages,
  w3m,
  dante,
  gawk,
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.18.2";

  src = fetchFromSourcehut {
    owner = "~rjarry";
    repo = "aerc";
    rev = version;
    hash = "sha256-J4W7ynJ5DpE97sILENNt6eya04aiq9DWBhlytsVmZHg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-STQzc25gRozNHKjjYb8J8CL5WMhnx+nTJOGbuFmUYSU=";

  nativeBuildInputs = [
    scdoc
    python3Packages.wrapPython
  ];

  patches = [
    ./runtime-libexec.patch

    # patch to fix a encoding problem with gpg signed messages
    (fetchpatch {
      url = "https://git.sr.ht/~rjarry/aerc/commit/7346d20.patch";
      hash = "sha256-OCm8BcovYN2IDSgslZklQxkGVkSYQ8HLCrf2+DRB2mM=";
    })
  ];

  postPatch = ''
    substituteAllInPlace config/aerc.conf
    substituteAllInPlace config/config.go
    substituteAllInPlace doc/aerc-config.5.scd

    # Prevent buildGoModule from trying to build this
    rm contrib/linters.go
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  pythonPath = [
    python3Packages.vobject
  ];

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

  meta = with lib; {
    description = "Email client for your terminal";
    homepage = "https://aerc-mail.org/";
    maintainers = [ ];
    mainProgram = "aerc";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
