{
  copyDesktopItems,
  fetchurl,
  lib,
  makeDesktopItem,
  makeWrapper,
  pkgs,
  stdenv,

  dotnetSupport ? false, # Untested integration with .NET, disabled for now
}:

let
  platformName =
    {
      "x86_64-linux" = "linux-x86-64";
      "aarch64-linux" = "linux-arm64";
      "x86_64-darwin" = "macosx-x86-64"; # Doesn't compile with clang yet
      "aarch64-darwin" = "macosx-armv6"; # Need to do more testing on macOS
    }
    .${stdenv.system} or null;
in
stdenv.mkDerivation rec {
  pname = "eiffelstudio";
  version = "25.02.98732";

  src = fetchurl {
    url = "https://ftp.eiffel.com/pub/download/latest/pp/PorterPackage_${lib.versions.majorMinor version}_rev_${lib.versions.patch version}.tar";
    sha256 = "sha256-/XoewqCeh1NfB3ve9UL+0WZfZ5DEa4N7REl67Ftlxt0=";
  };

  nativeBuildInputs =
    with pkgs;
    [
      coreutils
      copyDesktopItems
      gnused
      makeWrapper
      pax
      pkg-config
    ]
    ++ lib.optional dotnetSupport dotnet-sdk;

  buildInputs =
    with pkgs;
    [
      adwaita-icon-theme
      cairo
      gdk-pixbuf
      glib
      gtk3
      pango
      pkg-config
      xorg.libX11
      xorg.libXtst
    ]
    ++ lib.optional dotnetSupport dotnet-runtime;

  sourceRoot = "PorterPackage";
  #patches = [ ./build-debugging.patch ]; # Leaving this here in case I need it later
  postPatch = ''
    # A script inside this tarball depends on hardcoded coreutils + gnused paths
    tar -xf c.tar.bz2

    # All of these (not shebang) references to /bin must be replaced
    for i in cp ln mv rm; do
      substituteInPlace C/CONFIGS/${platformName} --replace-fail "/bin/$i" "${pkgs.coreutils}/bin/$i"
    done
    substituteInPlace C/CONFIGS/${platformName} --replace-fail "/bin/sed" "${pkgs.gnused}/bin/sed"

    # Re-assemble the tarball with fixed up paths
    rm c.tar.bz2
    tar -cjSf c.tar.bz2 C
  '';

  hardeningDisable = [ "format" ]; # Allow printf without a format string
  # Better explained here: https://fedoraproject.org/wiki/Format-Security-FAQ
  buildPhase = ''
    runHook preBuild
    ./compile_exes ${platformName}
    ./make_images ${platformName}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt

    cp -r Eiffel_${lib.versions.majorMinor version} $out/opt
    install -Dm444 packaging/logo.png $out/share/icons/estudio.png

    makeWrapper $out/opt/Eiffel_${lib.versions.majorMinor version}/studio/spec/${platformName}/bin/ec $out/bin/ec --set ISE_EIFFEL $out/opt/Eiffel_${lib.versions.majorMinor version} --set ISE_PLATFORM ${platformName}
    makeWrapper $out/opt/Eiffel_${lib.versions.majorMinor version}/studio/spec/${platformName}/bin/estudio $out/bin/estudio --set ISE_EIFFEL $out/opt/Eiffel_${lib.versions.majorMinor version} --set ISE_PLATFORM ${platformName}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "estudio";
      desktopName = "EiffelStudio";
      exec = "estudio";
      keywords = [ "Development" ];
      categories = [ "Development" ];
      icon = "estudio";
    })
  ];

  meta = {
    description = "IDE for the Eiffel language";
    longDescription = ''
      EiffelStudio is a software application that provides comprehensive
      facilities to programmers for software development, powered by the Eiffel
      language. It has a suite of tools and services that enable programmers to
      produce correct, reliable, and maintainable software and control the
      development process.
    '';
    license = lib.licenses.gpl2Only;
    homepage = "https://dev.eiffel.com";
    maintainers = with lib.maintainers; [ jonhermansen ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "estudio";
  };
}
