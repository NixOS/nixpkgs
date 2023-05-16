<<<<<<< HEAD
{ lib
, stdenv
, curl
, jq
, htmlq
, xorg
, alsa-lib
, freetype
, p7zip
, autoPatchelfHook
, writeShellScript
, zlib
, libjack2
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, librsvg
}:
let
  versionForFile = v: builtins.replaceStrings [ "." ] [ "" ] v;

  mkPianoteq =
    { name
    , mainProgram
    , startupWMClass
    , src
    , version
    , archdir ? if (stdenv.hostPlatform.system == "aarch64-linux") then "arm-64bit" else "x86-64bit"
    , ...
    }:
=======
{ lib, stdenv, curl, jq, htmlq, xorg, alsa-lib, freetype, p7zip, autoPatchelfHook, writeShellScript, zlib, libjack2, makeWrapper }:
let
  versionForFile = v: builtins.replaceStrings ["."] [""] v;

  mkPianoteq = { name, src, version, archdir ? if (stdenv.hostPlatform.system == "aarch64-linux") then "arm-64bit" else "x86-64bit", ... }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    stdenv.mkDerivation rec {
      inherit src version;

      pname = "pianoteq-${name}";

      unpackPhase = ''
        ${p7zip}/bin/7z x $src
      '';

      nativeBuildInputs = [
        autoPatchelfHook
<<<<<<< HEAD
        copyDesktopItems
        makeWrapper
        librsvg
=======
        makeWrapper
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      ];

      buildInputs = [
        stdenv.cc.cc.lib
<<<<<<< HEAD
        xorg.libX11 # libX11.so.6
        xorg.libXext # libXext.so.6
        alsa-lib # libasound.so.2
        freetype # libfreetype.so.6
      ];

      desktopItems = [
        (makeDesktopItem {
          name = pname;
          exec = ''"${mainProgram}"'';
          desktopName = mainProgram;
          icon = "pianoteq";
          comment = meta.description;
          categories = [ "AudioVideo" "Audio"  "Recorder" ];
          startupNotify = false;
          inherit startupWMClass;
        })
      ];

      installPhase = ''
        runHook preInstall
=======
        xorg.libX11      # libX11.so.6
        xorg.libXext     # libXext.so.6
        alsa-lib          # libasound.so.2
        freetype         # libfreetype.so.6
      ];

      installPhase = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        mkdir -p $out/bin
        mv -t $out/bin Pianoteq*/${archdir}/*
        for f in $out/bin/Pianoteq*; do
          if [ -x "$f" ] && [ -f "$f" ]; then
            wrapProgram "$f" --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath (buildInputs ++ [
                xorg.libXcursor
                xorg.libXinerama
                xorg.libXrandr
                libjack2
                zlib
              ])
            }
          fi
        done
<<<<<<< HEAD
        install -Dm644 ${./pianoteq.svg} $out/share/icons/hicolor/scalable/apps/pianoteq.svg
        for size in 16 22 32 48 64 128 256; do
          dir=$out/share/icons/hicolor/"$size"x"$size"/apps
          mkdir -p $dir
          rsvg-convert \
            --keep-aspect-ratio \
            --width $size \
            --height $size \
            --output $dir/pianoteq.png \
            ${./pianoteq.svg}
        done
        runHook postInstall
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      '';

      meta = with lib; {
        homepage = "https://www.modartt.com/pianoteq";
        description = "Software synthesizer that features real-time MIDI-control of digital physically modeled pianos and related instruments";
        license = licenses.unfree;
<<<<<<< HEAD
        inherit mainProgram;
        platforms = [ "x86_64-linux" "aarch64-linux" ];
        maintainers = with maintainers; [ mausch ners ];
      };
    };

  fetchWithCurlScript = { name, hash, script, impureEnvVars ? [ ] }:
=======
        platforms = [ "x86_64-linux" "aarch64-linux" ];
        maintainers = [ maintainers.mausch ];
      };
    };

  fetchWithCurlScript = { name, sha256, script, impureEnvVars ? [] }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    stdenv.mkDerivation {
      inherit name;
      builder = writeShellScript "builder.sh" ''
        source $stdenv/setup

        curlVersion=$(${curl}/bin/curl -V | head -1 | cut -d' ' -f2)

        # Curl flags to handle redirects, not use EPSV, handle cookies for
        # servers to need them during redirects, and work on SSL without a
        # certificate (this isn't a security problem because we check the
        # cryptographic hash of the output anyway).
        curl=(
            ${curl}/bin/curl
            --location
            --max-redirs 20
            --retry 3
            --disable-epsv
            --cookie-jar cookies
            --insecure
            --user-agent "curl/$curlVersion Nixpkgs/${lib.trivial.release}"
            $NIX_CURL_FLAGS
        )

        ${script}

      '';
      nativeBuildInputs = [ curl ];
      outputHashAlgo = "sha256";
<<<<<<< HEAD
      outputHash = hash;
=======
      outputHash = sha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ impureEnvVars ++ [
        # This variable allows the user to pass additional options to curl
        "NIX_CURL_FLAGS"
      ];
    };

<<<<<<< HEAD
  fetchPianoteqTrial = { name, hash }:
    fetchWithCurlScript {
      inherit name hash;
=======
  fetchPianoteqTrial = { name, sha256 }:
    fetchWithCurlScript {
      inherit name sha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      script = ''
        html=$(
          "''${curl[@]}" --silent --request GET \
            --cookie cookies \
            --header "accept: */*" \
            'https://www.modartt.com/try?file=${name}'
        )

        signature="$(echo "$html" | ${htmlq}/bin/htmlq '#download-form' --attribute action | cut -f2 -d'&' | cut -f2 -d=)"

        json=$(
          "''${curl[@]}" --silent --request POST \
          --cookie cookies \
          --header "modartt-json: request" \
          --header "origin: https://www.modartt.com" \
          --header "content-type: application/json; charset=UTF-8" \
          --header "accept: application/json, text/javascript, */*" \
          --data-raw '{"file": "${name}", "get": "url", "signature": "'"$signature"'"}' \
          https://www.modartt.com/api/0/download
        )

        url=$(echo $json | ${jq}/bin/jq -r .url)
        if [ "$url" == "null"  ]; then
          echo "Could not get download URL, open an issue on https://github.com/NixOS/nixpkgs"
          return 1
        fi
        "''${curl[@]}" --progress-bar --cookie cookies -o $out "$url"
      '';
    };

<<<<<<< HEAD
  fetchPianoteqWithLogin = { name, hash }:
    fetchWithCurlScript {
      inherit name hash;
=======
  fetchPianoteqWithLogin = { name, sha256 }:
    fetchWithCurlScript {
      inherit name sha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      impureEnvVars = [ "NIX_MODARTT_USERNAME" "NIX_MODARTT_PASSWORD" ];

      script = ''
        if [ -z "''${NIX_MODARTT_USERNAME}" -o -z "''${NIX_MODARTT_PASSWORD}" ]; then
          echo "Error: Downloading a personal Pianoteq instance requires the nix building process (nix-daemon in multi user mode) to have the NIX_MODARTT_USERNAME and NIX_MODARTT_PASSWORD env vars set." >&2
          exit 1
        fi

        "''${curl[@]}" -s -o /dev/null "https://www.modartt.com/user_area"

        ${jq}/bin/jq -n "{connect: 1, login: \"''${NIX_MODARTT_USERNAME}\", password: \"''${NIX_MODARTT_PASSWORD}\"}" > login.json

        "''${curl[@]}" --silent --request POST \
          --cookie cookies \
          --referer "https://www.modartt.com/user_area" \
          --header "modartt-json: request" \
          --header "origin: https://www.modartt.com" \
          --header "content-type: application/json; charset=UTF-8" \
          --header "accept: application/json, text/javascript, */*" \
          --data @login.json \
          https://www.modartt.com/api/0/session

        json=$(
          "''${curl[@]}" --silent --request POST \
          --cookie cookies \
          --header "modartt-json: request" \
          --header "origin: https://www.modartt.com" \
          --header "content-type: application/json; charset=UTF-8" \
          --header "accept: application/json, text/javascript, */*" \
          --data-raw '{"file": "${name}", "get": "url"}' \
          https://www.modartt.com/api/0/download
        )

        url=$(echo $json | ${jq}/bin/jq -r .url)
        "''${curl[@]}" --progress-bar --cookie cookies -o $out "$url"
      '';
    };

<<<<<<< HEAD
in
{
  # TODO currently can't install more than one because `lame` clashes
  stage-trial = mkPianoteq rec {
    name = "stage-trial";
    mainProgram = "Pianoteq 8 STAGE";
    startupWMClass = "Pianoteq STAGE Trial";
    version = "8.1.1";
    src = fetchPianoteqTrial {
      name = "pianoteq_stage_linux_trial_v${versionForFile version}.7z";
      hash = "sha256-jMGv95WiD7UHAuSzKgauLhlsNvO/RWVrHd2Yf3kiUTo=";
=======
in {
  # TODO currently can't install more than one because `lame` clashes
  stage-trial = mkPianoteq rec {
    name = "stage-trial";
    version = "8.0.8";
    src = fetchPianoteqTrial {
      name = "pianoteq_stage_linux_trial_v${versionForFile version}.7z";
      sha256 = "sha256-dp0bTzzh4aQ2KQ3z9zk+3meKQY4YRYQ86rccHd3+hAQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
  standard-trial = mkPianoteq rec {
    name = "standard-trial";
<<<<<<< HEAD
    mainProgram = "Pianoteq 8";
    startupWMClass = "Pianoteq Trial";
    version = "8.1.1";
    src = fetchPianoteqTrial {
      name = "pianoteq_linux_trial_v${versionForFile version}.7z";
      hash = "sha256-pL4tJMV8OTVLT4fwABcImWO+iaVe9gCdDN3rbkL+noc=";
=======
    version = "8.0.8";
    src = fetchPianoteqTrial {
      name = "pianoteq_linux_trial_v${versionForFile version}.7z";
      sha256 = "sha256-LSrnrjkEhsX9TirUUFs9tNqH2A3cTt3I7YTfcTT6EP8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
  stage-6 = mkPianoteq rec {
    name = "stage-6";
<<<<<<< HEAD
    mainProgram = "Pianoteq 6 STAGE";
    startupWMClass = "Pianoteq STAGE";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    version = "6.7.3";
    archdir = if (stdenv.hostPlatform.system == "aarch64-linux") then throw "Pianoteq stage-6 is not supported on aarch64-linux" else "amd64";
    src = fetchPianoteqWithLogin {
      name = "pianoteq_stage_linux_v${versionForFile version}.7z";
<<<<<<< HEAD
      hash = "0jy0hkdynhwv0zhrqkby0hdphgmcc09wxmy74rhg9afm1pzl91jy";
=======
      sha256 = "0jy0hkdynhwv0zhrqkby0hdphgmcc09wxmy74rhg9afm1pzl91jy";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
  stage-7 = mkPianoteq rec {
    name = "stage-7";
<<<<<<< HEAD
    mainProgram = "Pianoteq 7 STAGE";
    startupWMClass = "Pianoteq STAGE";
    version = "7.3.0";
    src = fetchPianoteqWithLogin {
      name = "pianoteq_stage_linux_v${versionForFile version}.7z";
      hash = "05w7sv9v38r6ljz9xai816w5z2qqwx88hcfjm241fvgbs54125hx";
    };
  };
  standard-8 = mkPianoteq rec {
    name = "standard-8";
    mainProgram = "Pianoteq 8";
    startupWMClass = "Pianoteq";
    version = "8.1.1";
    src = fetchPianoteqWithLogin {
      name = "pianoteq_linux_v${versionForFile version}.7z";
      hash = "sha256-vWvo+ctJ0yN6XeJZZVhA3Ul9eWJWAh7Qo54w0TpOiVw=";
=======
    version = "7.3.0";
    src = fetchPianoteqWithLogin {
      name = "pianoteq_stage_linux_v${versionForFile version}.7z";
      sha256 = "05w7sv9v38r6ljz9xai816w5z2qqwx88hcfjm241fvgbs54125hx";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
  # TODO other paid binaries, I don't own that so I don't know their hash.
}
