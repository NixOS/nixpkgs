{ lib
, stdenv
, fetchurl
, asar
, dpkg
, electron
, makeWrapper
, nixosTests
, undmg
}:

let
  inherit (stdenv.hostPlatform) system;

  sources = import ./sources.nix;

  systemArgs = rec {
    x86_64-linux = {
      src = fetchurl sources.x86_64-linux;

      nativeBuildInputs = [
        asar
        dpkg
        makeWrapper
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

        makeWrapper ${electron}/bin/electron $out/bin/breitbandmessung \
          --add-flags $out/share/breitbandmessung/resources/build/electron.js

        # Fix the desktop link
        substituteInPlace $out/share/applications/breitbandmessung.desktop \
          --replace /opt/Breitbandmessung $out/bin
      '';
    };

    x86_64-darwin = {
      src = fetchurl sources.x86_64-darwin;

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
  inherit (sources) version;

  passthru.tests = { inherit (nixosTests) breitbandmessung; };
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Broadband internet speed test app from the german Bundesnetzagentur";
    homepage = "https://www.breitbandmessung.de";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ b4dm4n ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
} // systemArgs)
