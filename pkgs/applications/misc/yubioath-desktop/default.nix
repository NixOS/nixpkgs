{ stdenv, fetchurl,  python27Packages, pcsclite, yubikey-personalization }:

python27Packages.buildPythonApplication rec {
    namePrefix = "";
    name = "yubioath-desktop-${version}";
    version = "3.1.0";

    src = fetchurl {
      url = "https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-${version}.tar.gz";
      sha256 = "0jfvllgh88g2vwd8sg6willlnn2hq05nd9d3xmv98lhl7gyy1akw";
    };

    doCheck = false;

    buildInputs = [ stdenv ];

    propagatedBuildInputs = [ python27Packages.pycrypto python27Packages.click python27Packages.pyscard python27Packages.pyside ];

    # Need LD_PRELOAD for libykpers as the Nix cpython disables ctypes.cdll.LoadLibrary
    # support that the yubicommon library uses to load libykpers
    makeWrapperArgs = ''--prefix LD_LIBRARY_PATH : "${stdenv.lib.getLib pcsclite}/lib:${yubikey-personalization}/lib" --prefix LD_PRELOAD : "${yubikey-personalization}/lib/libykpers-1.so"'';

    postInstall = ''
      mkdir -p $out/share/applications
      cp resources/yubioath.desktop $out/share/applications/yubioath.desktop
      mkdir -p $out/share/yubioath/icons
      cp resources/yubioath*.{icns,ico,png,xpm} $out/share/yubioath/icons
      substituteInPlace $out/share/applications/yubioath.desktop \
        --replace 'Exec=yubioath-gui' "Exec=$out/bin/yubioath-gui" \
        --replace 'Icon=yubioath' "Icon=$out/share/yubioath/icons"

    '';

    meta = {
      description = "Yubikey Desktop Authenticator";

      homepage = https://www.yubico.com/support/knowledge-base/categories/articles/yubico-authenticator-download/;

      license = stdenv.lib.licenses.gpl3;
    };
}
