{ stdenv, lib, makeWrapper, fetchurl, unzip, atomEnv, makeDesktopItem, buildFHSUserEnv }:

let
  version = "0.10.0";
  name = "mist-${version}";

  throwSystem = throw "Unsupported system: ${stdenv.system}";

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

  mist = stdenv.mkDerivation {
    inherit name version;

    src = {
      i686-linux = fetchurl {
        url = "https://github.com/ethereum/mist/releases/download/v${version}/Mist-linux32-${urlVersion}.zip";
        sha256 = "01hvxlm9w522pwvsjdy18gsrapkfjr7d1jjl4bqjjysxnjaaj2lk";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/ethereum/mist/releases/download/v${version}/Mist-linux64-${urlVersion}.zip";
        sha256 = "01k17j7fdfhxfd26njdsiwap0xnka2536k9ydk32czd8db7ya9zi";
      };
    }.${stdenv.system} or throwSystem;

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
        --set-rpath "${atomEnv.libPath}:$out/lib/mist" \
        $out/lib/mist/mist
    '';
  };
in
buildFHSUserEnv {
  name = "mist";

  targetPkgs = pkgs: with pkgs; [
     mist
  ];

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications
  '';

  runScript = "mist";
}
