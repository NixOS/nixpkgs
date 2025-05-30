{
  lib,
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  copyDesktopItems,
  curl,
  freetype,
  htmlq,
  jq,
  libglvnd,
  librsvg,
  makeDesktopItem,
  makeWrapper,
  p7zip,
  writeShellScript,
}:
let
  versionForFile = v: builtins.replaceStrings [ "." ] [ "" ] v;

  archdirs =
    if stdenv.hostPlatform.isx86_64 then
      [
        "x86-64bit"
        "amd64"
      ]
    else if stdenv.hostPlatform.isAarch64 then
      [
        "arm-64bit"
        "arm"
      ]
    else
      throw "unsupported platform";

  mkPianoteq =
    {
      name,
      mainProgram,
      startupWMClass,
      src,
      version,
      ...
    }:
    stdenv.mkDerivation rec {
      inherit src version;

      pname = "pianoteq-${name}";

      unpackPhase = ''
        ${p7zip}/bin/7z x $src
      '';

      nativeBuildInputs = [
        autoPatchelfHook
        copyDesktopItems
        makeWrapper
        librsvg
      ];

      buildInputs = [
        (lib.getLib stdenv.cc.cc) # libgcc_s.so.1, libstdc++.so.6
        alsa-lib # libasound.so.2
        freetype # libfreetype.so.6
        libglvnd # libGL.so.1
      ];

      desktopItems = [
        (makeDesktopItem {
          name = pname;
          exec = ''"${mainProgram}"'';
          desktopName = mainProgram;
          icon = "pianoteq";
          comment = meta.description;
          categories = [
            "AudioVideo"
            "Audio"
            "Recorder"
          ];
          startupNotify = false;
          inherit startupWMClass;
        })
      ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        mv -t $out/bin ${builtins.concatStringsSep " " (builtins.map (dir: "Pianoteq*/${dir}/*") archdirs)}
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
      '';

      meta = with lib; {
        homepage = "https://www.modartt.com/pianoteq";
        description = "Software synthesizer that features real-time MIDI-control of digital physically modeled pianos and related instruments";
        license = licenses.unfree;
        inherit mainProgram;
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        maintainers = with maintainers; [
          mausch
          ners
        ];
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };
    };

  fetchWithCurlScript =
    {
      name,
      hash,
      script,
      impureEnvVars ? [ ],
    }:
    stdenv.mkDerivation {
      inherit name;
      builder = writeShellScript "builder.sh" ''
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
      outputHash = hash;

      impureEnvVars =
        lib.fetchers.proxyImpureEnvVars
        ++ impureEnvVars
        ++ [
          # This variable allows the user to pass additional options to curl
          "NIX_CURL_FLAGS"
        ];
    };

  fetchPianoteqTrial =
    { name, hash }:
    fetchWithCurlScript {
      inherit name hash;
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

  fetchPianoteqWithLogin =
    { name, hash }:
    fetchWithCurlScript {
      inherit name hash;

      impureEnvVars = [
        "NIX_MODARTT_USERNAME"
        "NIX_MODARTT_PASSWORD"
      ];

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

  version6 = "6.7.3";
  version7 = "7.5.4";
  version8 = "8.4.0";

  mkStandard =
    version: hash:
    mkPianoteq {
      name = "standard";
      mainProgram = "Pianoteq ${lib.versions.major version}";
      startupWMClass = "Pianoteq";
      inherit version;
      src = fetchPianoteqWithLogin {
        name = "pianoteq_linux_v${versionForFile version}.7z";
        inherit hash;
      };
    };
  mkStage =
    version: hash:
    mkPianoteq {
      name = "stage";
      mainProgram = "Pianoteq ${lib.versions.major version} STAGE";
      startupWMClass = "Pianoteq STAGE";
      inherit version;
      src = fetchPianoteqWithLogin {
        name = "pianoteq_stage_linux_v${versionForFile version}.7z";
        inherit hash;
      };
    };
  mkStandardTrial =
    version: hash:
    mkPianoteq {
      name = "standard-trial";
      mainProgram = "Pianoteq ${lib.versions.major version}";
      startupWMClass = "Pianoteq Trial";
      inherit version;
      src = fetchPianoteqTrial {
        name = "pianoteq_linux_trial_v${versionForFile version}.7z";
        inherit hash;
      };
    };
  mkStageTrial =
    version: hash:
    mkPianoteq {
      name = "stage-trial";
      mainProgram = "Pianoteq ${lib.versions.major version} STAGE";
      startupWMClass = "Pianoteq STAGE Trial";
      inherit version;
      src = fetchPianoteqTrial {
        name = "pianoteq_stage_linux_trial_v${versionForFile version}.7z";
        inherit hash;
      };
    };
in
{
  standard_8 = mkStandard version8 "sha256-ZDGB/SOOz+sWz7P+sNzyaipEH452n8zq5LleO3ztSXc=";
  stage_8 = mkStage version8 "";
  standard-trial_8 = mkStandardTrial version8 "sha256-K3LbAWxciXt9hVAyRayxSoE/IYJ38Fd03+j0s7ZsMuw=";
  stage-trial_8 = mkStageTrial version8 "sha256-k0p7SnkEq90bqIlT7PTYAQuhKEDVi+srHwYrpMUtIbM=";

  standard_7 = mkStandard version7 "sha256-TA9CiuT21fQedlMUGz7bNNxYun5ArmRjvIxjOGqXDCs=";
  stage_7 = mkStage version7 "";
  standard-trial_7 = mkStandardTrial version7 "sha256-3a3+SKTEhvDtqK5Kg4E6KiLvn5+j6JN6ntIb72u2bdQ=";
  stage-trial_7 = mkStageTrial version7 "sha256-ybtq+hjnaQxpLxv2KE0ZcbQXtn5DJJsnMwCmh3rlrIc=";

  standard_6 = mkStandard version6 "sha256-u6ZNpmHFVOk+r+6Q8OURSfAi41cxMoDvaEXrTtHEAVY=";
  stage_6 = mkStage version6 "";
  standard-trial_6 = mkStandardTrial version6 "sha256-nHTAqosOJqC0VnRw2/xVpZ6y02vvau6CgfNmgiN/AHs=";
  stage-trial_6 = mkStageTrial version6 "sha256-zrv0c/Mxt1EysR7ZvmxtksXAF5MyXTFMNj4KAdO3QnE=";
}
