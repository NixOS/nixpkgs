{
  lib,
  _7zz,
  alsa-lib,
  systemd,
  wrapGAppsHook4,
  autoPatchelfHook,
  blas,
  dpkg,
  fetchurl,
  gtk3,
  libglvnd,
  libxkbcommon,
  makeShellWrapper,
  libgbm,
  musl,
  nss,
  patchelf,
  openssl,
  stdenv,
  xorg,
}:
let
  pname = "positron-bin";
  version = "2025.10.0-199";
in
stdenv.mkDerivation {
  inherit version pname;

  src =
    if stdenv.hostPlatform.isDarwin then
      fetchurl {
        url = "https://cdn.posit.co/positron/releases/mac/universal/Positron-${version}-universal.dmg";
        hash = "sha256-iYEkuMQZkn/71bjHCvltTK6EC5l45kNdBhcK6TUB1hM=";
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "https://cdn.posit.co/positron/releases/deb/arm64/Positron-${version}-arm64.deb";
        hash = "sha256-JkgFuVebyDRqGh2ZcTZitVWzRSYdatKCtXWL1GMb0ZM=";
      }
    else
      fetchurl {
        url = "https://cdn.posit.co/positron/releases/deb/x86_64/Positron-${version}-x64.deb";
        hash = "sha256-ycheOOKirLhDiNIh2Bg/7KBTau7YPGGWHLkRmZJkrnk=";
      };

  buildInputs = [
    makeShellWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    gtk3
    libglvnd
    libxkbcommon
    libgbm
    musl
    nss
    stdenv.cc.cc
    openssl
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libxkbfile
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    blas
    patchelf
  ];

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      dpkg
      wrapGAppsHook4
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      _7zz
    ];

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    # Needed to fix the "Zygote could not fork" error.
    (lib.getLib systemd)
  ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall
        mkdir -p "$out/Applications" "$out/bin"
        cp -r . "$out/Applications/Positron.app"

        # Positron will use the system version of BLAS if we don't provide the nix version.
        wrapProgram "$out/Applications/Positron.app/Contents/Resources/app/bin/code" \
          --prefix DYLD_INSERT_LIBRARIES : "${lib.makeLibraryPath [ blas ]}/libblas.dylib" \
          --add-flags "--disable-updates"

        ln -s "$out/Applications/Positron.app/Contents/Resources/app/bin/code" "$out/bin/positron"
        runHook postInstall
      ''
    else
      ''
        runHook preInstall
        mkdir -p "$out/share"
        cp -r usr/share/pixmaps "$out/share/pixmaps"
        cp -r usr/share/positron "$out/share/positron"

        mkdir -p "$out/share/applications"
        install -m 444 -D usr/share/applications/positron.desktop "$out/share/applications/positron.desktop"
        substituteInPlace "$out/share/applications/positron.desktop" \
          --replace-fail \
          "Icon=co.posit.positron" \
          "Icon=$out/share/pixmaps/co.posit.positron.png" \
          --replace-fail \
          "Exec=/usr/share/positron/positron %F" \
          "Exec=$out/share/positron/.positron-wrapped %F" \
          --replace-fail \
          "/usr/share/positron/positron --new-window %F" \
          "$out/share/positron/.positron-wrapped --new-window %F"

        # Fix libGL.so not found errors.
        wrapProgram "$out/share/positron/positron" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libglvnd ]}" \
          --add-flags "--disable-updates"


        mkdir -p "$out/bin"
        ln -s "$out/share/positron/positron" "$out/bin/positron"
        runHook postInstall
      '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Positron, a next-generation data science IDE";
    homepage = "https://github.com/posit-dev/positron";
    license = licenses.elastic20;
    maintainers = with maintainers; [
      b-rodrigues
      detroyejr
    ];
    mainProgram = "positron";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ]
    ++ platforms.darwin;
  };
}
