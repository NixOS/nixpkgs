{ stdenv, makeWrapper, fetchurl, unzip, atomEnv, makeDesktopItem, buildFHSUserEnv, gtk2 }:

let
  version = "0.11.1";
  pname = "mist";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  meta = with stdenv.lib; {
    description = "Browse and use Ðapps on the Ethereum network";
    homepage = https://github.com/ethereum/mist;
    license = licenses.gpl3;
    maintainers = with maintainers; [];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };

  urlVersion = builtins.replaceStrings ["."] ["-"] version;

  desktopItem = makeDesktopItem rec {
    name = "Mist";
    exec = "mist";
    icon = "mist";
    desktopName = name;
    genericName = "Mist Browser";
    categories = "Network;";
  };

  mist = stdenv.lib.appendToName "unwrapped" (stdenv.mkDerivation {
    inherit pname version meta;

    src = {
      i686-linux = fetchurl {
        url = "https://github.com/ethereum/mist/releases/download/v${version}/Mist-linux32-${urlVersion}.zip";
        sha256 = "1ffzp9aa0g6w3d5pzp69fljk3sd51cbqdgxa1x16vj106sqm0gj7";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/ethereum/mist/releases/download/v${version}/Mist-linux64-${urlVersion}.zip";
        sha256 = "0yx4x72l8gk68yh9saki48zgqx8k92xnkm79dc651wdpd5c25cz3";
      };
    }.${stdenv.hostPlatform.system} or throwSystem;

    buildInputs = [ unzip makeWrapper ];

    buildCommand = ''
      mkdir -p $out/lib/mist $out/bin
      unzip -d $out/lib/mist $src
      ln -s $out/lib/mist/mist $out/bin
      fixupPhase
      mkdir -p $out/share/applications
      ln -s ${desktopItem}/share/applications/* $out/share/applications
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:${gtk2}/lib:$out/lib/mist" \
        $out/lib/mist/mist
    '';
  });
in
buildFHSUserEnv {
  name = "mist";
  inherit meta;

  targetPkgs = pkgs: with pkgs; [
     mist
  ];

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications
  '';

  runScript = "mist";
}
