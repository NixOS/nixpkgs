{
  lib,
  multiStdenv,
  fetchFromGitHub,
  wine,
  cmake,
  makeWrapper,
  wrapQtAppsHook,
  file,
  libX11,
  qt5,
  vst2-sdk,
}:

let
  version = "1.3.3";

  wine-wow64 = wine.override {
    wineRelease = "stable";
    wineBuild = "wineWow";
  };
in
multiStdenv.mkDerivation {
  pname = "airwave";
  inherit version;

  src = fetchFromGitHub {
    owner = "phantom-code";
    repo = "airwave";
    rev = version;
    hash = "sha256-mvT0b0auKiu1T8cbR9RoBT94hKSnXDamqkIQPnUqVq0=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    file
    libX11
    qt5.qtbase
    wine-wow64
  ];

  postPatch = ''
    # Binaries not used directly should land in libexec/.
    substituteInPlace src/common/storage.cpp --replace '"/bin"' '"/libexec"'

    # For airwave-host-32.exe.so, point wineg++ to 32-bit versions of
    # these libraries, as $NIX_LDFLAGS contains only 64-bit ones.
    substituteInPlace src/host/CMakeLists.txt --replace '-m32' \
      '-m32 -L${lib.getLib wine-wow64}/lib -L${lib.getLib wine-wow64}/lib/wine -L${lib.getLib multiStdenv.cc.libc}/lib/32'
  '';

  # libstdc++.so link gets lost in 64-bit executables during
  # shrinking.
  dontPatchELF = true;

  # Cf. https://github.com/phantom-code/airwave/issues/57
  hardeningDisable = [ "format" ];

  cmakeFlags = [ "-DVSTSDK_PATH=${vst2-sdk}" ];

  postInstall = ''
    mv $out/bin $out/libexec
    mkdir $out/bin
    mv $out/libexec/airwave-manager $out/bin
    wrapProgram $out/libexec/airwave-host-32.exe --set WINELOADER ${lib.getExe' wine-wow64 "wine"}
    wrapProgram $out/libexec/airwave-host-64.exe --set WINELOADER ${lib.getExe' wine-wow64 "wine64"}
  '';

  meta = {
    description = "WINE-based VST bridge for Linux VST hosts";
    longDescription = ''
      Airwave is a wine based VST bridge, that allows for the use of
      Windows 32- and 64-bit VST 2.4 audio plugins with Linux VST
      hosts. Due to the use of shared memory, only one extra copying
      is made for each data transfer. Airwave also uses the XEMBED
      protocol to correctly embed the plugin editor into the host
      window.
    '';
    homepage = "https://github.com/phantom-code/airwave";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ michalrus ];
    hydraPlatforms = [ ];
  };
}
