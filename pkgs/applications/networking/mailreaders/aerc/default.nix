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
<<<<<<< HEAD
  version = "0.15.2";
=======
  version = "0.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~rjarry";
    repo = "aerc";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-OQDA4AHDcAdDzpwNSi8rW1FKjfYaFktOwiM0FEHPd70=";
  };

  proxyVendor = true;
  vendorHash = "sha256-NWOySC0czNgNOakpxFguZLtmEI7AvjJQKXDE2vFWeZg=";
=======
    hash = "sha256-qC7lNqjgljUqRUp+S7vBVLPyRB3+Ie5UOxuio+Q88hg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-MVek3TQpE3AChGyQ4z01fLfkcGKJcckmFV21ww9zT7M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  nativeBuildInputs = [
    scdoc
    python3.pkgs.wrapPython
  ];

  patches = [
<<<<<<< HEAD
    ./runtime-libexec.patch
=======
    ./runtime-sharedir.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    substituteAllInPlace config/aerc.conf
    substituteAllInPlace config/config.go
    substituteAllInPlace doc/aerc-config.5.scd
<<<<<<< HEAD

    # Prevent buildGoModule from trying to build this
    rm contrib/linters.go
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  pythonPath = [
<<<<<<< HEAD
    python3.pkgs.vobject
=======
    python3.pkgs.colorama
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    wrapProgram $out/libexec/aerc/filters/html \
      --prefix PATH ":"  ${lib.makeBinPath [ w3m dante ]}
    wrapProgram $out/libexec/aerc/filters/html-unsafe \
      --prefix PATH ":" ${lib.makeBinPath [ w3m dante ]}
    patchShebangs $out/libexec/aerc/filters
=======
    wrapProgram $out/share/aerc/filters/html \
      --prefix PATH ":"  ${lib.makeBinPath [ w3m dante ]}
    wrapProgram $out/share/aerc/filters/html-unsafe \
      --prefix PATH ":" ${lib.makeBinPath [ w3m dante ]}
    patchShebangs $out/share/aerc/filters
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "An email client for your terminal";
    homepage = "https://aerc-mail.org/";
    maintainers = with maintainers; [ tadeokondrak ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
