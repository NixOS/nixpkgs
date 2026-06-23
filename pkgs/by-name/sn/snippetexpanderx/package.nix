{
  lib,
  stdenv,
  pkg-config,
  vala,
  wrapGAppsHook3,
  installShellFiles,
  scdoc,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  gtk3,
  ibus,
  libgee,
  libx11,
  snippetexpanderd,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (snippetexpanderd) src version;

  pname = "snippetexpanderx";

  sourceRoot = "${finalAttrs.src.name}/cmd/snippetexpanderx";

  nativeBuildInputs = [
    pkg-config
    vala
    wrapGAppsHook3
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
    libx11
    snippetexpanderd
  ];

  makeFlags = [ "VERSION=${finalAttrs.src.rev}" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m555 snippetexpanderx $out/bin/
    installManPage snippetexpanderx.1
    runHook postInstall
  '';

  # There are no tests.
  doCheck = false;

  meta = {
    description = "Your little expandable text snippet helper auto expander daemon";
    homepage = "https://snippetexpander.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "snippetexpanderx";
  };
})
