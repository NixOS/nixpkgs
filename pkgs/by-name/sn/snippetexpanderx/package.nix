{ lib
, stdenv
, fetchFromSourcehut
, pkg-config
, vala
, wrapGAppsHook
, installShellFiles
, scdoc
, at-spi2-atk
, at-spi2-core
, dbus
, gtk3
, ibus
, libgee
, xorg
, snippetexpanderd
}:

stdenv.mkDerivation rec {
  inherit (snippetexpanderd) src version;

  pname = "snippetexpanderx";

  sourceRoot = "source/cmd/snippetexpanderx";

  nativeBuildInputs = [
    pkg-config
    vala
    wrapGAppsHook
    installShellFiles
    scdoc
  ];

  buildInputs = [
    at-spi2-atk
    at-spi2-core
    dbus
    gtk3
    ibus
    libgee
    xorg.libX11
    snippetexpanderd
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m555 snippetexpanderx $out/bin/
    installManPage snippetexpanderx.1
    runHook postInstall
  '';

  # There are no tests.
  doCheck = false;

  meta = with lib; {
    description = "Your little expandable text snippet helper auto expander daemon";
    homepage = "https://snippetexpander.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ianmjones ];
    platforms = platforms.linux;
    mainProgram = "snippetexpanderx";
  };
}
