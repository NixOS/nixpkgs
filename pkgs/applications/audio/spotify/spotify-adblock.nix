/*

to test this package:

* mkdir -p /etc/nixos/extra-pkgs
* save as /etc/nixos/extra-pkgs/spotify-adblock.nix
* add to /etc/nixos/configuration.nix:

  nixpkgs.overlays = [ ( self: super: {
    spotify-adblock = pkgs.callPackage ./extra-pkgs/spotify-adblock.nix {};
  })];
  
  environment.systemPackages = with pkgs; [
    spotify-adblock
  ];

*/

{ pkgs, lib, stdenv, fetchFromGitHub, fetchFromBitbucket }:

stdenv.mkDerivation rec {

  pname = "spotify-adblock";
  version = "1.4";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock-linux";
    rev = "v${version}";
    sha256 = "Pcbtyld/D7UoynkevX4wb/mXBFbvz7uT9bD/D55h3Ko=";
  };

  # TODO only fetch path `/include`? (with SVN?)
  cef-src = fetchFromBitbucket {
    owner = "chromiumembedded";
    repo = "cef";
    rev = cef-branch;
    sha256 = cef-sha256;
  };

  # sample spotify.version: "1.1.26.501.gbe11e53b-15"
  # FIXME attribute 'version' missing -> (why) is `pkgs.spotify` not eval-ed at this point?
  spotify-version-short = builtins.elemAt (builtins.match "^([^.]+\.[^.]+\.[^.]+)\." pkgs.spotify.version) 0; # -> 1.1.26

  cef-branch = builtins.getAttr spotify-version-short chromium-branch-of-spotify-version;
  cef-sha256 = builtins.getAttr spotify-version-short cef-sha256-of-branch;

  buildInputs = [
    pkgs.spotify
  ];

  preBuild = ''
    ln -s -v "${cef-src}/include" ./

    # debug
    echo ls include/capi/
    ls include/capi/
  '';

  installPhase = ''
    # debug
    echo install: spotify = ${pkgs.spotify}
    echo install: spotify.version = ${pkgs.spotify.version}
    echo install: ls ${pkgs.spotify}
    ls ${pkgs.spotify}
    echo install: ls -l ${pkgs.spotify}/bin
    ls -l ${pkgs.spotify}/bin

    mkdir -p $out/{lib,bin}

    cp spotify-adblock.so $out/lib/

    # wrapper
    str=""
    str+="#!${pkgs.runtimeShell}\n"
    str+="LD_PRELOAD=$out/lib/spotify-adblock.so exec ${pkgs.spotify}/bin/spotify\n"
    echo "$str" >$out/bin/spotify-adblock
    chmod +x $out/bin/spotify-adblock
  '';

  cef-sha256-of-branch = {
    "3945" = "0000000000000000000000000000000000000000000000000000"; # TODO
  };

  /*
    // generate chromium-branch-of-spotify-version from https://www.spotify.com/ps-en/opensource/
    var lastBranch = null;
    var lastVersion = null;
    console.log(
      Array.from(document.querySelectorAll('#content-main > div > div > table > tbody > tr'))
      //.slice(0, 2) // debug
      .map(tr => {
        const td = tr.children;
        const spotifyVersion = td[0].innerHTML.match(/^([^.]+\.[^.]+\.[^.]+)\..+/)[1];
        if (lastVersion == spotifyVersion) return '';
        // https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding
        const chromiumBranch = td[2].children[0].innerHTML.split('.').slice(-2)[0];
        const res = (lastBranch == chromiumBranch ? ' ' : '\n') + `"${spotifyVersion}" = "${chromiumBranch}";`;
        lastBranch = chromiumBranch;
        lastVersion = spotifyVersion;
        return res;
      }).join('')
    );
  */

  # TODO move to spotify nix?
  chromium-branch-of-spotify-version = {
    "1.1.56" = "4280"; "1.1.55" = "4280"; "1.1.54" = "4280"; "1.1.53" = "4280";
    "1.1.52" = "4240"; "1.1.51" = "4240"; "1.1.48" = "4240"; "1.1.47" = "4240";
    "1.1.46" = "4183"; "1.1.45" = "4183"; "1.1.44" = "4183"; "1.1.43" = "4183";
    "1.1.42" = "4147"; "1.1.41" = "4147"; "1.1.40" = "4147";
    "1.1.39" = "4103"; "1.1.38" = "4103"; "1.1.37" = "4103"; "1.1.36" = "4103";
    "1.1.35" = "4044"; "1.1.34" = "4044";
    "1.1.33" = "3987";
    "1.1.32" = "3945"; "1.1.31" = "3945"; "1.1.30" = "3945"; "1.1.29" = "3945"; "1.1.28" = "3945"; "1.1.27" = "3945"; "1.1.26" = "3945";
    "1.1.25" = "3904"; "1.1.24" = "3904"; "1.1.22" = "3904";
    "1.1.21" = "3809"; "1.1.20" = "3809"; "1.1.19" = "3809"; "1.1.18" = "3809"; "1.1.17" = "3809";
    "1.1.16" = "3770"; "1.1.15" = "3770"; "1.1.14" = "3770"; "1.1.12" = "3770";
    "1.1.10" = "3729"; "1.1.9" = "3729";
    "1.1.8" = "3578"; "1.1.7" = "3578"; "1.1.6" = "3578"; "1.1.5" = "3578"; "1.1.4" = "3578"; "1.1.3" = "3578"; "1.1.2" = "3578";
    "1.1.1" = "3538"; "1.1.0" = "3538"; "1.0.99" = "3538"; "1.0.98" = "3538"; "1.0.96" = "3538"; "1.0.95" = "3538";
    "1.0.94" = "3497"; "1.0.93" = "3497"; "1.0.92" = "3497";
    "1.0.77" = "3325";
    "1.0.75" = "3282";
    "1.0.74" = "3163"; "1.0.73" = "3163"; "1.0.72" = "3163"; "1.0.70" = "3163"; "1.0.69" = "3163";
    "1.0.57" = "2987"; "1.0.56" = "2987"; "1.0.55" = "2987"; "1.0.54" = "2987";
    "1.0.53" = "2924"; "1.0.52" = "2924"; "1.0.51" = "2924"; "1.0.50" = "2924";
    "1.0.37" = "2743"; "1.0.36" = "2743";
    "1.0.34" = "2704"; "1.0.33" = "2704"; "1.0.32" = "2704";
    "1.0.31" = "2526"; "1.0.29" = "2526"; "1.0.28" = "2526"; "1.0.27" = "2526"; "1.0.26" = "2526"; "1.0.25" = "2526"; "1.0.24" = "2526"; "1.0.23" = "2526";
    "1.0.21" = "2454"; "1.0.20" = "2454"; "1.0.19" = "2454"; "1.0.18" = "2454"; "1.0.16" = "2454"; "1.0.15" = "2454";
    "1.0.14" = "2357"; "1.0.13" = "2357"; "1.0.12" = "2357"; "1.0.11" = "2357";
    "1.0.10" = "2272"; "1.0.9" = "2272"; "1.0.8" = "2272"; "1.0.7" = "2272"; "1.0.6" = "2272"; "1.0.5" = "2272";
    "1.0.4" = "2171"; "1.0.3" = "2171"; "1.0.2" = "2171"; "1.0.1" = "2171";
    "0.9.14" = "1547"; "0.9.13" = "1547"; "0.9.12" = "1547"; "0.9.11" = "1547"; "0.9.10" = "1547"; "0.9.8" = "1547"; "0.9.7" = "1547";
  };

  /*
    # https://github.com/abba23/spotify-adblock-linux#build
    cef-tarball = fetchurl {
      # -> 264 MByte
      url = "https://cef-builds.spotifycdn.com/cef_binary_88.1.6%2Bg4fe33a1%2Bchromium-88.0.4324.96_linux64_minimal.tar.bz2";
      name = "cef.tar.bz2";
      sha256 = "Na9Cjp9hsoyOsidUGZ07c825km0F8byUdI3ajGETz1c=";
    };
  */

  # this should be enough for build:
  #git clone --depth 1  https://bitbucket.org/chromiumembedded/cef.git --branch 3729
  # -> 30 MByte

  meta = with lib; {
    description = "Spotify adblocker for Linux";
    homepage = "https://github.com/abba23/spotify-adblock-linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
