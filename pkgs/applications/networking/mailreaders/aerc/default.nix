{ lib
, buildGoModule
, fetchFromSourcehut
, ncurses
, notmuch
, scdoc
, python3
, w3m
, dante
, gawk
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.17.0";

  src = fetchFromSourcehut {
    owner = "~rjarry";
    repo = "aerc";
    rev = version;
    hash = "sha256-XpVUUAtm6o4DXIouTKRX/8mLERb/4nA+VUGeB21mfjE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-AHEhIWa6PP8f+hhIdY+0brLF2HYhvTal7qXfCwG9iyo=";

  nativeBuildInputs = [
    scdoc
    python3.pkgs.wrapPython
  ];

  patches = [
    ./runtime-libexec.patch
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
    python3.pkgs.vobject
  ];

  buildInputs = [ python3 notmuch gawk ];

  installPhase = ''
    runHook preInstall

    make $makeFlags GOFLAGS="$GOFLAGS -tags=notmuch" install

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/aerc \
      --prefix PATH ":" "${lib.makeBinPath [ ncurses ]}"
    wrapProgram $out/libexec/aerc/filters/html \
      --prefix PATH ":"  ${lib.makeBinPath [ w3m dante ]}
    wrapProgram $out/libexec/aerc/filters/html-unsafe \
      --prefix PATH ":" ${lib.makeBinPath [ w3m dante ]}
    patchShebangs $out/libexec/aerc/filters
  '';

  meta = with lib; {
    description = "An email client for your terminal";
    homepage = "https://aerc-mail.org/";
    maintainers = with maintainers; [ tadeokondrak ];
    mainProgram = "aerc";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
