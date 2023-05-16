{ lib
, stdenv
, fetchurl
<<<<<<< HEAD
, asar
, dpkg
, electron_24
, makeWrapper
, nixosTests
=======
, dpkg
, electron_16
, makeWrapper
, nixosTests
, nodePackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, undmg
}:

let
  inherit (stdenv.hostPlatform) system;

<<<<<<< HEAD
  version = "3.3.0";
=======
  version = "3.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  systemArgs = rec {
    x86_64-linux = rec {
      src = fetchurl {
        url = "https://download.breitbandmessung.de/bbm/Breitbandmessung-${version}-linux.deb";
<<<<<<< HEAD
        sha256 = "sha256-12mbdxklje9msnRtNk1RAtIg3OCybev/vUersDZj2i4=";
      };

      nativeBuildInputs = [
        asar
        dpkg
        makeWrapper
=======
        sha256 = "sha256-jSP+H9ej9Wd+swBZSy9uMi2ExSTZ191FGZhqaocTl7w=";
      };

      nativeBuildInputs = [
        dpkg
        makeWrapper
        nodePackages.asar
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      ];

      unpackPhase = "dpkg-deb -x $src .";

      installPhase = ''
        mkdir -p $out/bin
        mv usr/share $out/share
        mkdir -p $out/share/breitbandmessung/resources

        asar e opt/Breitbandmessung/resources/app.asar $out/share/breitbandmessung/resources

        # At first start, the program checks for supported operating systems by using the `bizzby-lsb-release`
        # module and only runs when it finds Debian/Ubuntu. So we present us as Debian and make it happy.
        cat <<EOF > $out/share/breitbandmessung/resources/node_modules/bizzby-lsb-release/lib/lsb-release.js
        module.exports = function release() {
          return {
            distributorID: "Debian",
            description: "Debian GNU/Linux 10 (buster)",
            release: "10",
            codename: "buster"
          }
        }
        EOF

<<<<<<< HEAD
        makeWrapper ${electron_24}/bin/electron $out/bin/breitbandmessung \
=======
        makeWrapper ${electron_16}/bin/electron $out/bin/breitbandmessung \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          --add-flags $out/share/breitbandmessung/resources/build/electron.js

        # Fix the desktop link
        substituteInPlace $out/share/applications/breitbandmessung.desktop \
          --replace /opt/Breitbandmessung $out/bin
      '';
    };

    x86_64-darwin = {
      src = fetchurl {
        url = "https://download.breitbandmessung.de/bbm/Breitbandmessung-${version}-mac.dmg";
<<<<<<< HEAD
        sha256 = "sha256-a27R/N13i4qU2znTKz+LGxSdgSzJ0MzIHeiPHyRd65k=";
=======
        sha256 = "sha256-2c8mDKJuHDSw7p52EKnJO5vr2kNTLU6r9pmGPANjE20=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ b4dm4n ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
} // systemArgs)
