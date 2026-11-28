{
  fetchurl,
  lib,
  stdenvNoCC,
  buildFHSEnv,
  runCommand,
  dpkg,
}:
let
  source =
    if stdenvNoCC.isx86_64 then
      rec {
        version = "1.0.51-0";
        src = fetchurl {
          url = "https://repo-feed.flightradar24.com/pool/linux-stable/f/fr24feed/fr24feed_${version}_amd64.deb";
          hash = "sha256-yGTCBxEgRkErbZeiu6/EMIwrQA+8Qu9R55OhSA1iko0=";
        };
      }
    else if stdenvNoCC.isi686 then
      rec {
        version = "1.0.51-0";
        src = fetchurl {
          url = "https://repo-feed.flightradar24.com/pool/linux-stable/f/fr24feed/fr24feed_${version}_i386.deb";
          hash = "sha256-8KP9HrACfNTamzp1o2aqecvEe0FUn+DZSCvMWFaRp1c=";
        };
      }
    else if stdenvNoCC.isAarch32 then
      rec {
        version = "1.0.51-0";
        src = fetchurl {
          url = "https://repo-feed.flightradar24.com/pool/raspberrypi-stable/f/fr24feed/fr24feed_${version}_armhf.deb";
          hash = "sha256-33TeySayN7L4rxCDbFKaLt/xfRqLRniWfmbwI51cq8A=";
        };
      }
    else if stdenvNoCC.isAarch64 then
      rec {
        version = "1.0.51-0";
        src = fetchurl {
          url = "https://repo-feed.flightradar24.com/pool/raspberrypi-stable/f/fr24feed/fr24feed_${version}_arm64.deb";
          hash = "sha256-dQ7N/atF/D2IAuk4ZUkrhC5FzfXMHU6+pq0IvScGnhw=";
        };
      }
    else
      throw "Unsupported architecture";

  distPkg =
    runCommand "fr24feed-dist"
      {
        nativeBuildInputs = [ dpkg ];
      }
      ''
        dpkg -x ${source.src} .
        install -Dm755 usr/bin/fr24feed $out/bin/fr24feed
        install -Dm755 usr/bin/fr24feed-signup-adsb $out/bin/fr24feed-signup-adsb
        install -Dm755 usr/bin/fr24feed-signup-uat $out/bin/fr24feed-signup-uat
      '';

  fhsArgs = {
    name = "fr24feed-fhs";
    targetPkgs = _pkgs: [
      _pkgs.procps
      _pkgs.bash
    ];
    runScript = "${distPkg}/bin/fr24feed";

    unshareUser = false;
    unshareIpc = false;
    unsharePid = false;
    unshareNet = false;
    unshareUts = false;
    unshareCgroup = false;
  };

  # FHS for starting main program
  fhs = buildFHSEnv fhsArgs;

  # FHS for starting signup programs, link fr24feed.ini to current directory
  fhs-signup = buildFHSEnv (
    fhsArgs
    // {
      extraBwrapArgs = [
        "--symlink $(pwd)/fr24feed.ini /etc/fr24feed.ini"
        "--symlink $(pwd)/fr24uat-feed.ini /etc/fr24uat-feed.ini"
      ];
    }
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fr24feed";
  inherit (source) version;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${fhs}/bin/fr24feed-fhs $out/bin/fr24feed
    install -Dm755 ${fhs-signup}/bin/fr24feed-fhs $out/bin/.fr24feed-signup
    install -Dm755 ${distPkg}/bin/fr24feed-signup-adsb $out/bin/fr24feed-signup-adsb
    install -Dm755 ${distPkg}/bin/fr24feed-signup-uat $out/bin/fr24feed-signup-uat

    runHook postInstall
  '';

  postFixup = ''
    # Signup scripts need FHS for a few utils in /usr/bin
    substituteInPlace $out/bin/fr24feed-signup-adsb \
      --replace-fail "/usr/bin/fr24feed" "$out/bin/.fr24feed-signup"
    printf "\necho \"NixOS note: fr24feed.ini is generated in current directory\"\n" >> $out/bin/fr24feed-signup-adsb

    substituteInPlace $out/bin/fr24feed-signup-uat \
      --replace-fail "/usr/bin/fr24feed" "$out/bin/.fr24feed-signup"
    printf "\necho \"NixOS note: fr24uat-feed.ini is generated in current directory\"\n" >> $out/bin/fr24feed-signup-uat
  '';

  passthru = { inherit distPkg; };

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Flightradar24 Decoder & Feeder lets you effortlessly share ADS-B data with Flightradar24";
    homepage = "https://www.flightradar24.com/share-your-data";
    license = lib.licenses.unfree;
    mainProgram = "fr24feed";
  };
})
