# Evaluates all the accessible paths in nixpkgs.
# *This only builds on Linux* since it requires the Linux sandbox isolation to
# be able to write in various places while evaluating inside the sandbox.
#
# This file is used by nixpkgs CI (see .github/workflows/eval.yml) as well as
# being used directly as an entry point in Lix's CI (in `flake.nix` in the Lix
# repo).
#
# If you know you are doing a breaking API change, please ping the nixpkgs CI
# maintainers and the Lix maintainers (`nix eval -f . lib.teams.lix`).
{
  callPackage,
  lib,
  runCommand,
  writeShellScript,
  symlinkJoin,
  time,
  procps,
  nix,
  jq,
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

  supportedSystems = builtins.fromJSON (builtins.readFile ../supportedSystems.json);

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
            --option eval-system "${evalSystem}" > $out/paths.json
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
          nix-env -f "${nixpkgs}/pkgs/top-level/release-outpaths-parallel.nix" \
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
          # This immediately halts all xargs processes
          kill $PPID
        elif [[ -s "$outputDir/stderr/$myChunk" ]]; then
          echo "Nixpkgs on $system evaluated with warnings, aborting"
          kill $PPID
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
        ];
        env = {
          inherit evalSystem chunkSize;
        };
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
            availMemory=$(free -b | grep Mem | awk '{print $7}')
            freeSwap=$(free -b | grep Swap | awk '{print $4}')
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
