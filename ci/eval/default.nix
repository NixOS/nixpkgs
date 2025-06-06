{
  callPackage,
  lib,
  stdenv,
  runCommand,
  writeShellScript,
  writeText,
  symlinkJoin,
  time,
  procps,
  nixVersions,
  jq,
  python3,
  darwin,
}:

let
  nixpkgs =
    with lib.fileset;
    toSource {
      root = ../..;
      fileset = unions (
        map (lib.path.append ../..) [
          "default.nix"
          "doc"
          "lib"
          "maintainers"
          "nixos"
          "pkgs"
          ".version"
          "ci/supportedSystems.json"
        ]
      );
    };

  nix = nixVersions.latest;

  supportedSystems = builtins.fromJSON (builtins.readFile ../supportedSystems.json);

  # TODO(winterqt): Upstream this to Nix/Lix, then eventually drop from here.
  sandboxProfile = ''
    (allow file-read-metadata (literal "${builtins.storeDir}/.links"))
  '';

  attrpathsSuperset =
    {
      evalSystem,
    }:
    runCommand "attrpaths-superset.json"
      {
        src = nixpkgs;
        nativeBuildInputs = [
          nix
          time
        ];
        inherit sandboxProfile;
      }
      ''
        export NIX_STATE_DIR=$(mktemp -d)
        mkdir $out
        export GC_INITIAL_HEAP_SIZE=4g
        command time -f "Attribute eval done [%MKB max resident, %Es elapsed] %C" \
          nix-instantiate --eval --strict --json --show-trace \
            "$src/pkgs/top-level/release-attrpaths-superset.nix" \
            -A paths \
            -I "$src" \
            --option restrict-eval true \
            --option allow-import-from-derivation false \
            --option eval-system "${evalSystem}" \
            --arg enableWarnings false > $out/paths.json
      '';

  singleSystem =
    {
      # The system to evaluate.
      # Note that this is intentionally not called `system`,
      # because `--argstr system` would only be passed to the ci/default.nix file!
      evalSystem,
      # The path to the `paths.json` file from `attrpathsSuperset`
      attrpathFile ? "${attrpathsSuperset { inherit evalSystem; }}/paths.json",
      # The number of attributes per chunk, see ./README.md for more info.
      chunkSize,
      checkMeta ? true,

      # Don't try to eval packages marked as broken.
      includeBroken ? false,
      # Whether to just evaluate a single chunk for quick testing
      quickTest ? false,
    }:
    let
      abortCmd =
        if stdenv.isDarwin then
          ''
            # For some reason, `kill` (or `kill -9`) won't
            # actually kill an entire process tree on macOS
            # as it does on Linux. So instead, we'll just
            # use xargs' native termination feature, which
            # will at least guarantee that the iteration
            # will be stopped.
            #
            # (Yes, technically we can just keep the `kill`
            # command so that xargs dies and then the pending
            # chunks will finish, but I'd rather just do this
            # if it's going to have the same effect anyways.)
            exit 255
          ''
        else
          ''
            # This immediately halts all xargs processes
            kill $PPID
          '';

      singleChunk = writeShellScript "single-chunk" ''
        set -euo pipefail
        chunkSize=$1
        myChunk=$2
        system=$3
        outputDir=$4

        export NIX_SHOW_STATS=1
        export NIX_SHOW_STATS_PATH="$outputDir/stats/$myChunk"
        echo "Chunk $myChunk on $system start"
        set +e
        command time -o "$outputDir/timestats/$myChunk" \
          -f "Chunk $myChunk on $system done [%MKB max resident, %Es elapsed] %C" \
          nix-env -f "${nixpkgs}/pkgs/top-level/release-attrpaths-parallel.nix" \
          --eval-system "$system" \
          --option restrict-eval true \
          --option allow-import-from-derivation false \
          --query --available \
          --out-path --json \
          --show-trace \
          --arg chunkSize "$chunkSize" \
          --arg myChunk "$myChunk" \
          --arg attrpathFile "${attrpathFile}" \
          --arg systems "[ \"$system\" ]" \
          --arg checkMeta ${lib.boolToString checkMeta} \
          --arg includeBroken ${lib.boolToString includeBroken} \
          -I ${nixpkgs} \
          -I ${attrpathFile} \
          > "$outputDir/result/$myChunk" \
          2> "$outputDir/stderr/$myChunk"
        exitCode=$?
        set -e
        cat "$outputDir/stderr/$myChunk"
        cat "$outputDir/timestats/$myChunk"
        if (( exitCode != 0 )); then
          echo "Evaluation failed with exit code $exitCode"
          ${abortCmd}
        elif [[ -s "$outputDir/stderr/$myChunk" ]]; then
          echo "Nixpkgs on $system evaluated with warnings, aborting"
          ${abortCmd}
        fi
      '';
    in
    runCommand "nixpkgs-eval-${evalSystem}"
      {
        nativeBuildInputs = [
          nix
          time
          procps
          jq
        ] ++ lib.optional stdenv.isDarwin darwin.system_cmds;
        env = {
          inherit evalSystem chunkSize;
        };
        inherit sandboxProfile;
      }
      ''
        export NIX_STATE_DIR=$(mktemp -d)
        nix-store --init

        echo "System: $evalSystem"
        cores=$NIX_BUILD_CORES
        echo "Cores: $cores"
        attrCount=$(jq length "${attrpathFile}")
        echo "Attribute count: $attrCount"
        echo "Chunk size: $chunkSize"
        # Same as `attrCount / chunkSize` but rounded up
        chunkCount=$(( (attrCount - 1) / chunkSize + 1 ))
        echo "Chunk count: $chunkCount"

        mkdir -p $out/${evalSystem}

        # Record and print stats on free memory and swap in the background
        (
          while true; do
            ${
              if stdenv.isDarwin then
                ''
                  # Based on https://apple.stackexchange.com/a/48195

                  output=$(vm_stat | sed 's/\.//g')
                  freeBlocks=$(awk '/free/ { print $3 }' <<<$output)
                  inactiveBlocks=$(awk '/inactive/ { print $3 }' <<<$output)
                  speculativeBlocks=$(awk '/speculative/ { print $3 }' <<<$output)
                  availMemory=$(( (freeBlocks+inactiveBlocks+speculativeBlocks) * $(pagesize) ))
                  freeSwap=$(( $(sysctl vm.swapusage | awk '{ printf "%d", $10 }') * 1024 * 1024 ))
                ''
              else
                ''
                  availMemory=$(free -b | grep Mem | awk '{print $7}')
                  freeSwap=$(free -b | grep Swap | awk '{print $4}')
                ''
            }
            echo "Available memory: $(( availMemory / 1024 / 1024 )) MiB, free swap: $(( freeSwap / 1024 / 1024 )) MiB"

            if [[ ! -f "$out/${evalSystem}/min-avail-memory" ]] || (( availMemory < $(<$out/${evalSystem}/min-avail-memory) )); then
              echo "$availMemory" > $out/${evalSystem}/min-avail-memory
            fi
            if [[ ! -f $out/${evalSystem}/min-free-swap ]] || (( availMemory < $(<$out/${evalSystem}/min-free-swap) )); then
              echo "$freeSwap" > $out/${evalSystem}/min-free-swap
            fi
            sleep 4
          done
        ) &

        trap "kill %%" EXIT

        seq_end=$(( chunkCount - 1 ))

        ${lib.optionalString quickTest ''
          seq_end=0
        ''}

        chunkOutputDir=$(mktemp -d)
        mkdir "$chunkOutputDir"/{result,stats,timestats,stderr}

        seq -w 0 "$seq_end" |
          command time -f "%e" -o "$out/${evalSystem}/total-time" \
          xargs -I{} -P"$cores" \
          ${singleChunk} "$chunkSize" {} "$evalSystem" "$chunkOutputDir"

        cp -r "$chunkOutputDir"/stats $out/${evalSystem}/stats-by-chunk

        if (( chunkSize * chunkCount != attrCount )); then
          # A final incomplete chunk would mess up the stats, don't include it
          rm "$chunkOutputDir"/stats/"$seq_end"
        fi

        cat "$chunkOutputDir"/result/* | jq -s 'add | map_values(.outputs)' > $out/${evalSystem}/paths.json
      '';

  diff = callPackage ./diff.nix { };

  combine =
    {
      diffDir,
    }:
    runCommand "combined-eval"
      {
        nativeBuildInputs = [
          jq
        ];
      }
      ''
        mkdir -p $out

        # Combine output paths from all systems
        cat ${diffDir}/*/diff.json | jq -s '
          reduce .[] as $item ({}; {
            added: (.added + $item.added),
            changed: (.changed + $item.changed),
            removed: (.removed + $item.removed)
          })
        ' > $out/combined-diff.json

        mkdir -p $out/before/stats
        for d in ${diffDir}/before/*; do
          cp -r "$d"/stats-by-chunk $out/before/stats/$(basename "$d")
        done

        mkdir -p $out/after/stats
        for d in ${diffDir}/after/*; do
          cp -r "$d"/stats-by-chunk $out/after/stats/$(basename "$d")
        done
      '';

  compare = callPackage ./compare { };

  full =
    {
      # Whether to evaluate on a specific set of systems, by default all are evaluated
      evalSystems ? if quickTest then [ "x86_64-linux" ] else supportedSystems,
      # The number of attributes per chunk, see ./README.md for more info.
      chunkSize,
      quickTest ? false,
    }:
    let
      diffs = symlinkJoin {
        name = "diffs";
        paths = map (
          evalSystem:
          let
            eval = singleSystem {
              inherit quickTest evalSystem chunkSize;
            };
          in
          diff {
            inherit evalSystem;
            # Local "full" evaluation doesn't do a real diff.
            beforeDir = eval;
            afterDir = eval;
          }
        ) evalSystems;
      };
    in
    combine {
      diffDir = diffs;
    };

in
{
  inherit
    attrpathsSuperset
    singleSystem
    diff
    combine
    compare
    # The above three are used by separate VMs in a GitHub workflow,
    # while the below is intended for testing on a single local machine
    full
    ;
}
