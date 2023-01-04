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
  version = "0.14.0";

  src = fetchFromSourcehut {
    owner = "~rjarry";
    repo = "aerc";
    rev = version;
    hash = "sha256-qC7lNqjgljUqRUp+S7vBVLPyRB3+Ie5UOxuio+Q88hg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-MVek3TQpE3AChGyQ4z01fLfkcGKJcckmFV21ww9zT7M=";

  doCheck = false;

  nativeBuildInputs = [
    scdoc
    python3.pkgs.wrapPython
  ];

  patches = [
    ./runtime-sharedir.patch
  ];

  postPatch = ''
    substituteAllInPlace config/aerc.conf
    substituteAllInPlace config/config.go
    substituteAllInPlace doc/aerc-config.5.scd
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  pythonPath = [
    python3.pkgs.colorama
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
    wrapProgram $out/share/aerc/filters/html \
      --prefix PATH ":"  ${lib.makeBinPath [ w3m dante ]}
    wrapProgram $out/share/aerc/filters/html-unsafe \
      --prefix PATH ":" ${lib.makeBinPath [ w3m dante ]}
    patchShebangs $out/share/aerc/filters
  '';

  meta = with lib; {
    description = "An email client for your terminal";
    homepage = "https://aerc-mail.org/";
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
