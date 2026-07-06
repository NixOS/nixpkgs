{
  lib,
  fetchFromGitHub,
  python3Packages,
  writeShellScript,
  common-updater-scripts,
  coreutils,
  gitMinimal,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nvibrant";
  version = finalAttrs.passthru._version;
  pyproject = true;

  passthru = {
    nvibrantVersion = "1.2.0";

    oldestDriverVersion = "515.43.04";
    latestDriverVersion = "595.58.03";

    _version = lib.concatStringsSep "-" [
      finalAttrs.passthru.nvibrantVersion
      "unstable"
      finalAttrs.passthru.latestDriverVersion
    ];

    srcAttrs = {
      nvibrant = fetchFromGitHub {
        owner = "tremeschin";
        repo = "nvibrant";
        name = "nvibrant";
        tag = "v${finalAttrs.passthru.nvibrantVersion}";
        hash = "sha256-OQo+VGWz8LNpsCdXbJXWWCrnVE0+t4s220uJ+pTHVKs=";
      };
      open-gpu = fetchFromGitHub {
        owner = "nvidia";
        repo = "open-gpu-kernel-modules";
        name = "open-gpu";
        tag = finalAttrs.passthru.oldestDriverVersion;
        hash = "sha256-pSVK5oVob4QBo18ULHnQfO3UrTcC5lDDrTR9ec9pDp8=";

        # since .git isn't deterministic, we can't use it to checkout tags in
        # the build phase, so instead we generate patches for each version
        # upgrade before .git is removed and apply them incrementally
        fetchTags = true;
        postCheckout = ''
          cd $out

          while IFS= read -r tag; do
            echo "adding $tag"
            echo "$tag" >> SOURCE_TAGS

            if [[ "$tag" == ${finalAttrs.passthru.latestDriverVersion} ]]; then
              echo 'reached end of known tags'
              break
            fi
          done < <(git tag --sort v:refname)

          mkdir PATCHES

          prev_tag=${finalAttrs.passthru.oldestDriverVersion}
          while IFS= read -r tag; do
            if [ "$prev_tag" == "$tag" ]; then continue; fi

            echo "generating patch: $prev_tag -> $tag"
            git diff --minimal --binary "$prev_tag" "$tag" \
              > "PATCHES/$tag.patch"

            prev_tag=$tag
          done < SOURCE_TAGS
          unset prev_tag

          rm -rf .git
        '';
      };
    };

    updateScript = writeShellScript "update-nvibrant" ''
      set -euo pipefail

      export PATH="${
        lib.makeBinPath [
          common-updater-scripts
          coreutils
          gitMinimal
        ]
      }:$PATH"

      list_tags() {
        git ls-remote --tags --sort v:refname --refs "$1" |
          cut --delimiter=/ --field=3-
      }

      readarray -t nvibrant_tags < <(list_tags \
        'https://github.com/tremeschin/nvibrant.git')

      readarray -t open_gpu_tags < <(list_tags \
        'https://github.com/nvidia/open-gpu-kernel-modules.git')

      update-source-version nvibrant "''${nvibrant_tags[-1]:1}" \
        --version-key=nvibrantVersion --source-key=srcAttrs.nvibrant \
        --ignore-same-hash --ignore-same-version

      update-source-version nvibrant "''${open_gpu_tags[0]}" \
        --version-key=oldestDriverVersion --source-key=srcAttrs.open-gpu \
        --ignore-same-hash --ignore-same-version

      update-source-version nvibrant "''${open_gpu_tags[-1]}" \
        --version-key=latestDriverVersion --source-key=srcAttrs.open-gpu \
        --ignore-same-hash --ignore-same-version
    '';
  };

  srcs = lib.attrValues finalAttrs.passthru.srcAttrs;
  sourceRoot = ".";

  postUnpack = ''
    mv open-gpu nvibrant/
    cd nvibrant
  '';

  # replaces code that depends on .git and uses of python -m {ninja,meson}
  patches = [ ./hatch_build.patch ];

  configurePhase = ''
    export OLDEST_DRIVER_VERSION=${finalAttrs.passthru.oldestDriverVersion}
  '';

  nativeBuildInputs = [ gitMinimal ];

  build-system = with python3Packages; [
    hatchling
    meson
    ninja
  ];

  dependencies = with python3Packages; [
    packaging
  ];

  meta = {
    description = "Configure NVIDIA's Digital Vibrance on Wayland";
    homepage = "https://github.com/Tremeschin/nvibrant";
    mainProgram = "nvibrant";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mikaeladev
    ];
  };
})
