{
  stdenv,
  runCommandLocal,
  lib,
  htmlq,
  curl,
  cacert,
  gtk3,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "gaw3";
  version = "20250128";

  # https://www.rvq.fr/php/ndl.php?id=gaw.*
  # https://www.rvq.fr/php/ndl.php?id=gaw3-20250128.tar.gz
  src =
    runCommandLocal "gaw3-${version}.tar.gz"
      {
        BASE = "https://www.rvq.fr/php/ndl.php";
        FNAME = "gaw3-${version}.tar.gz";

        nativeBuildInputs = [
          htmlq
          curl
        ];
        SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-3uO+209+cmu231iabyYmABmgegyxAxswWDWA/v8WSy0=";
      }
      ''
        # fetch download page
        html_form=$(
          curl "$BASE?id=$FNAME" |
            tr '\n' ' ' | tr -s ' ' | # minimize whitespace
            htmlq tr | # select table rows, one per line
            grep "<td>$FNAME</td>" | # filter for row of interest
            head -n1 | # first match, just in case
            htmlq form --base "$BASE"
        )

        declare -a curl_args=()

        # hidden fields
        declare -a input_names=()
        readarray -td $'\n' input_names < <(
          htmlq <<<"$html_form" "input[type=hidden]" -a name
        )
        for input_name in "''${input_names[@]}"; do
          input_value=$(
            htmlq <<<"$html_form" "input[type=hidden][name=''${input_name}]" -a value
          )
          echo "$input_name = $input_value"
          curl_args+=( --form "$input_name=$input_value" )
        done

        # destination
        curl_args+=(
          "https://www.rvq.fr/$( htmlq <<<"$html_form"  form -a action )"
        )

        # POST and download
        (set -x
          curl -X POST "''${curl_args[@]}" $NIX_CURL_FLAGS --output "$FNAME"
        )

        # unpack and strip root dir
        mkdir unpack/
        tar xvf "$FNAME" --directory=unpack/
        [[ "$(printf "%s\n" unpack/* | wc -l)" -eq 1 ]]
        cp -a unpack/* $out
      '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ];

  meta = with lib; {
    description = "Gtk Analog Wave viewer";
    mainProgram = "gaw";
    longDescription = ''
      Gaw is a software tool for displaying analog waveforms from
      sampled datas, for example from the output of simulators or
      input from sound cards. Data can be imported to gaw using files,
      direct tcp/ip connection or directly from the sound card.
    '';
    homepage = "https://www.rvq.fr/linux/gaw.php";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fbeffa ];
    platforms = platforms.linux;
  };
}
