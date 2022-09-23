{ lib
, buildGoModule
, fetchFromSourcehut
, ncurses
, notmuch
, scdoc
, python3
, w3m
, dante
}:

buildGoModule rec {
  pname = "aerc";
  version = "0.12.0";

  src = fetchFromSourcehut {
    owner = "~rjarry";
    repo = pname;
    rev = version;
    hash = "sha256-n5rRvLhCy2d8xUoTNyM5JYKGJWN0nEwkQeBCOpUrUrc=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Z1dW3cK3Anl8JpAfwppsSBRgV5SdRmQemOG+652z0KA=";

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

  buildInputs = [ python3 notmuch ];

  installPhase = ''
    runHook preInstall

    make $makeFlags GOFLAGS="$GOFLAGS -tags=notmuch" install

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/aerc --prefix PATH ":" \
      "$out/share/aerc/filters:${lib.makeBinPath [ ncurses ]}"
    wrapProgram $out/share/aerc/filters/html --prefix PATH ":" \
      ${lib.makeBinPath [ w3m dante ]}
  '';

  meta = with lib; {
    description = "An email client for your terminal";
    homepage = "https://aerc-mail.org/";
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
