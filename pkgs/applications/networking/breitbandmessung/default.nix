{ lib
, stdenv
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, autoPatchelfHook
, cairo
, cups
, dbus
, dpkg
, expat
, fetchurl
, gdk-pixbuf
, glib
, gtk3
, libdrm
, libxkbcommon
, makeWrapper
, mesa
, nixosTests
, nspr
, nss
, pango
, pciutils
, systemd
, undmg
, writeShellScriptBin
, xorg
}:

let
  inherit (stdenv.hostPlatform) system;

  version = "3.1.0";

  # At first start, the program checks for supported operating systems by calling `lsb_release -a`
  # and only runs when it finds Debian/Ubuntu. So we present us as Debian an make it happy.
  fake-lsb-release = writeShellScriptBin "lsb_release" ''
    echo "Distributor ID: Debian"
    echo "Description:    Debian GNU/Linux 10 (buster)"
    echo "Release:        10"
    echo "Codename:       buster"
  '';

  binPath = lib.makeBinPath [
    fake-lsb-release
  ];

  systemArgs = rec {
    x86_64-linux = rec {
      src = fetchurl {
        url = "https://download.breitbandmessung.de/bbm/Breitbandmessung-${version}-linux.deb";
        sha256 = "sha256-jSP+H9ej9Wd+swBZSy9uMi2ExSTZ191FGZhqaocTl7w=";
      };

      dontUnpack = true;

      nativeBuildInputs = [
        autoPatchelfHook
        dpkg
        makeWrapper
      ];

      buildInputs = runtimeDependencies;

      runtimeDependencies = [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        dbus
        expat
        gdk-pixbuf
        glib
        gtk3
        libdrm
        libxkbcommon
        mesa
        nspr
        nss
        pango
        pciutils
        systemd
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libxcb
        xorg.libxshmfence
      ];

      installPhase = ''
        dpkg-deb -x $src $out
        mkdir -p $out/bin

        chmod -R g-w $out

        addAutoPatchelfSearchPath --no-recurse $out/opt/Breitbandmessung
        autoPatchelfFile $out/opt/Breitbandmessung/breitbandmessung

        makeWrapper $out/opt/Breitbandmessung/breitbandmessung $out/bin/breitbandmessung \
          --prefix PATH : ${binPath}

        mv $out/usr/share $out/share
        rmdir $out/usr

        # Fix the desktop link
        substituteInPlace $out/share/applications/breitbandmessung.desktop \
          --replace /opt/Breitbandmessung $out/bin
      '';

      dontAutoPatchelf = true;
      dontPatchELF = true;
    };

    x86_64-darwin = {
      src = fetchurl {
        url = "https://download.breitbandmessung.de/bbm/Breitbandmessung-${version}-mac.dmg";
        sha256 = "sha256-2c8mDKJuHDSw7p52EKnJO5vr2kNTLU6r9pmGPANjE20=";
      };

      nativeBuildInputs = [ undmg ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/Applications/Breitbandmessung.app
        cp -R . $out/Applications/Breitbandmessung.app
        runHook postInstall
      '';
    };

    aarch64-darwin = x86_64-darwin;
  }.${system} or { src = throw "Unsupported system: ${system}"; };
in
stdenv.mkDerivation ({
  pname = "breitbandmessung";
  inherit version;

  passthru.tests = { inherit (nixosTests) breitbandmessung; };

  meta = with lib; {
    description = "Broadband internet speed test app from the german Bundesnetzagentur";
    homepage = "https://www.breitbandmessung.de";
    license = licenses.unfree;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
} // systemArgs)
