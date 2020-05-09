{ pkgs ? (import <nixpkgs> {}) }:
with pkgs;
let 
  version = "6.7.3";

  versionForFile = builtins.replaceStrings ["."] [""] version;

  mkPianoteq = { name, src, ... }:
    stdenv.mkDerivation rec {
      inherit src version;

      pname = name;

      unpackPhase = ''
        7z x $src
      '';

      nativeBuildInputs = [
        p7zip
        autoPatchelfHook
      ];

      buildInputs = [
        xorg.libX11      # libX11.so.6
        xorg.libXext     # libXext.so.6
        alsaLib          # libasound.so.2
        freetype         # libfreetype.so.6
      ];

      installPhase = ''
        mkdir -p $out/bin
        mv -t $out/bin Pianoteq*/amd64/*
      '';

      meta = with stdenv.lib; {
        homepage = https://www.modartt.com/pianoteq;
        description = "Software synthesizer that features real-time MIDI-control of digital physically modeled pianos and related instruments";
        license = licenses.unfree;
        platforms = [ "x86_64-linux" ]; # TODO extract binary according to each platform?
        maintainers = [ mausch ];
      };
    };

  fetchWithCurlScript = { name, sha256, script, impureEnvVars ? [] }:
    stdenv.mkDerivation {
      inherit name;
      builder = writeShellScript "builder.sh" ''
        source $stdenv/setup

        curlVersion=$(curl -V | head -1 | cut -d' ' -f2)

        # Curl flags to handle redirects, not use EPSV, handle cookies for
        # servers to need them during redirects, and work on SSL without a
        # certificate (this isn't a security problem because we check the
        # cryptographic hash of the output anyway).
        curl=(
            curl
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
      outputHash = sha256;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ impureEnvVars ++ [
        # This variable allows the user to pass additional options to curl
        "NIX_CURL_FLAGS"
      ];
    };

  fetchPianoteqTrial = { name, sha256 }: 
    fetchWithCurlScript {
      inherit name sha256;
      script = ''
          "''${curl[@]}" -s "https://www.modartt.com/try?file=${name}" | grep 'a href="try?q' | grep -Po 'href="\K[^"]*' > urlpath
          "''${curl[@]}" -b cookies --progress-bar -o $out "https://www.modartt.com/$(cat urlpath)"
      '';
    };

  fetchPianoteqWithLogin = { name, sha256 }:
    fetchWithCurlScript {
      inherit name sha256;

      impureEnvVars = [ "NIX_MODARTT_USERNAME" "NIX_MODARTT_PASSWORD" ];

      script = ''
        if [ -z "''${NIX_MODARTT_USERNAME}" -o -z "''${NIX_MODARTT_PASSWORD}" ]; then
          echo "Error: Downloading a personal Pianoteq instance requires the nix building process (nix-daemon in multi user mode) to have the NIX_MODARTT_USERNAME and NIX_MODARTT_PASSWORD env vars set." >&2
          exit 1
        fi

        "''${curl[@]}" -s -o /dev/null "https://www.modartt.com/user_area"

        "''${curl[@]}" -s \
          -b cookies \
          --referer "https://www.modartt.com/user_area" \
          --data-urlencode "umail=''${NIX_MODARTT_USERNAME}" \
          --data-urlencode "upass=''${NIX_MODARTT_PASSWORD}" \
          --data-urlencode "login_submit=" \
          -o /dev/null \
          "https://www.modartt.com/user_area"

        "''${curl[@]}" -b cookies \
          --referer "https://www.modartt.com/user_area" \
          --progress-bar -o $out \
          "https://www.modartt.com/download?file=${name}"

      '';
    };

in {
  # TODO currently can't install more than one because `lame` clashes
  pianoteq-stage-trial = mkPianoteq {
    name = "pianoteq-stage-trial";
    src = fetchPianoteqTrial {
      name = "pianoteq_stage_linux_trial_v${versionForFile}.7z";
      sha256 = "16qxv1n57h3gkjxaz189wmmsk6chrvy81i0rsy8s335x6ay77krx"; 
    };
  };
  pianoteq-standard-trial = mkPianoteq {
    name = "pianoteq-standard-trial";
    src = fetchPianoteqTrial {
      name = "pianoteq_linux_trial_v${versionForFile}.7z";
      sha256 = "1z1ypqrdj3qfzbzascljb69f28ig8ixcvhyay9ndik67hqbaxl6n"; 
    };
  };
  pianoteq-stage = mkPianoteq {
    name = "pianoteq-stage";
    src = fetchPianoteqWithLogin {
      name = "pianoteq_stage_linux_v${versionForFile}.7z";
      sha256 = "12cb166qkrp2380wsn26ip3a1hq7y5jknyip0wy1g7dnv0xhhxbq"; 
    };
  };
  # TODO pianoteq-standard. I don't own it so I don't know its hash.
}
