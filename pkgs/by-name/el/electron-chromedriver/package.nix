{ pkgs, lib, stdenv, fetchzip, autoPatchelfHook, libxcb }:
let
  allSpecs = {
    x86_64-linux = {
      system = "linux-x64";
      hash = "sha256-6FsvmU97Rdr6wRxgp14YsrTN2O6IZOWvZy6mvzoPzkc=";
    };

    aarch64-linux = {
      system = "linux-arm64";
      hash = "sha256-YuOEZ0EK4qWIUeUZsQWdvCAoERtdsN43kmQyb9j3GVA=";
    };

    x86_64-darwin = {
      system = "darwin-x64";
      hash = "sha256-IHO9jTnekgVLFWoGZUyjQVZkQWm+ZeVIxYTkTuON9wE=";
    };

    aarch64-darwin = {
      system = "darwin-arm64";
      hash = "sha256-jVifLkWTilmU+AlcDuEsoDkobGk56wLsnl9nTraaNSQ=";
    };
  };

  spec = allSpecs.${stdenv.hostPlatform.system}
    or (throw "missing electron chromedriver binary for ${stdenv.hostPlatform.system}");
  # corresponds to chromedriver 122.0.6261.57
  version = "29.0.1";
  # darwin distributions come with libffmpeg dependecy + icudtl.dat file
  darwinInstallLines = ''
    cp $src/libffmpeg.dylib $out/bin/libffmpeg.dylib
    cp $src/icudtl.dat $out/bin/icudtl.dat
  '';
in

stdenv.mkDerivation {
  pname = "electron-chromedriver";
  version = version;

  src = fetchzip {
    url = "https://github.com/electron/electron/releases/download/v${version}/chromedriver-v${version}-${spec.system}.zip";
    hash = spec.hash;
    stripRoot = false; # this .zip is a flat list of files, not a zipped directory
  };

  nativeBuildInputs = lib.lists.optional (!stdenv.isDarwin) autoPatchelfHook;

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib glib libxcb nspr nss
  ];

  installPhase = ''
    runHook preInstall
    install -m777 -D $src/chromedriver $out/bin/chromedriver
  '' + (lib.optionalString stdenv.isDarwin darwinInstallLines) + ''
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.electronjs.org/";
    description = "A WebDriver server for running Selenium tests on Chrome";
    longDescription = ''
      WebDriver is an open source tool for automated testing of webapps across
      many browsers. It provides capabilities for navigating to web pages, user
      input, JavaScript execution, and more. ChromeDriver is a standalone
      server that implements the W3C WebDriver standard. This is
      an unofficial build of ChromeDriver compiled by the Electronjs
      project.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ liammurphy14 ];
    platforms = attrNames allSpecs;
    mainProgram = "chromedriver";
  };

}
