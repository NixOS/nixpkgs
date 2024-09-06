{ stdenv, ffmpeg-full, pname, nodejs, getopt }: ''
    #!${stdenv.shell}

    port=8000
    host=0.0.0.0
    config=$(pwd)/config
    metadata=$(pwd)/metadata

    LONGOPTS=host:,port:,config:,metadata:,help
    args=$(${getopt}/bin/getopt -l "$LONGOPTS" -o h -- "$@")

    eval set -- "$args"

    while [ $# -ge 1 ]; do
      case "$1" in
        --)
          # No more options left.
          shift
          break
          ;;
        --host)
          host="$2"
          shift
          ;;
        --port)
          port="$2"
          shift
          ;;
        --config)
          if [[ "''${2:0:1}" = "/" ]]; then
            config="$2"
          else
            config="$(pwd)/$2"
          fi
          shift
          ;;
        --metadata)
          if [[ "''${2:0:1}" = "/" ]]; then
            metadata="$2"
          else
            metadata="$(pwd)/$2"
          fi
          shift
          ;;
        --help|-h)
          echo "Usage: audiobookshelf [--host <host>] [--port <port>] [--metadata <dir>] [--config <dir>]"
          exit 0
          ;;
      esac
      shift
    done

    NODE_ENV=production \
      SOURCE=nixpkgs \
      SKIP_BINARIES_CHECK=1 \
      FFMPEG_PATH=${ffmpeg-full}/bin/ffmpeg \
      FFPROBE_PATH=${ffmpeg-full}/bin/ffprobe \
      CONFIG_PATH="$config" \
      METADATA_PATH="$metadata" \
      PORT="$port" \
      HOST="$host" \''
