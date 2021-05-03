{ lib, stdenv, fetchurl, appimageTools, undmg, libsecret, libxshmfence }:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "keeweb";
  version = "1.17.0";
  name = "${pname}-${version}";

  suffix = {
    x86_64-linux = "linux.AppImage";
    x86_64-darwin = "mac.x64.dmg";
    aarch64-darwin = "mac.arm64.dmg";
  }.${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.${suffix}";
    sha256 = {
      x86_64-linux = "1c7zvwnd46d3lrlcdigv341flz44jl6mnvr6zqny5mfz221ynbj7";
      x86_64-darwin = "1n4haxychm5jjhjnpncavjh0wr4dagqi78qfsx5gwlv86hzryzwy";
      aarch64-darwin = "1j7z63cbfms02f2lhl949wy3lc376jw8kqmjfn9j949s0l5fanpb";
    }.${system} or throwSystem;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  meta = with lib; {
    description = "Free cross-platform password manager compatible with KeePass";
    homepage = "https://keeweb.info/";
    changelog = "https://github.com/keeweb/keeweb/blob/v${version}/release-notes.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };

  linux = appimageTools.wrapType2 rec {
    inherit name src meta;

    extraPkgs = pkgs: with pkgs; [ libsecret libxshmfence ];

    extraInstallCommands = ''
      mv $out/bin/{${name},${pname}}
      install -Dm644 ${appimageContents}/keeweb.desktop -t $out/share/applications
      install -Dm644 ${appimageContents}/keeweb.png -t $out/share/icons/hicolor/256x256/apps
      install -Dm644 ${appimageContents}/usr/share/mime/keeweb.xml -t $out/share/mime
      substituteInPlace $out/share/applications/keeweb.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux
