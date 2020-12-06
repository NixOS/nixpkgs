{ stdenv, fetchurl, appimageTools, undmg, libsecret }:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "keeweb";
  version = "1.16.0";
  name = "${pname}-${version}";

  suffix = {
    x86_64-linux = "linux.AppImage";
    x86_64-darwin = "mac.dmg";
  }.${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.${suffix}";
    sha256 = {
      x86_64-linux = "1pivic7n5nv00s8bb51i2jz2mxgjn92hkc8n0p8662ai1cdng47g";
      x86_64-darwin = "0q6k0qgkgzid9yjbfsfpp8l9dr0n8xp25a4jf2bxwickm4irs9mz";
    }.${system} or throwSystem;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  meta = with stdenv.lib; {
    description = "Free cross-platform password manager compatible with KeePass";
    homepage = "https://keeweb.info/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

  linux = appimageTools.wrapType2 rec {
    inherit name src meta;

    extraPkgs = pkgs: with pkgs; [ libsecret ];

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

    sourceRoot = "KeeWeb.app";

    installPhase = ''
      mkdir -p $out/Applications/KeeWeb.app
      cp -R . $out/Applications/KeeWeb.app
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux
