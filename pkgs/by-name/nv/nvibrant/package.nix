{
  lib,
  fetchFromGitHub,
  python3Packages,
  git,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nvibrant";
  version = "1.2.0";
  pyproject = true;

  srcs = [
    (fetchFromGitHub {
      owner = "Tremeschin";
      repo = "nvibrant";
      name = "nvibrant";
      tag = "v${finalAttrs.version}";
      hash = "sha256-OQo+VGWz8LNpsCdXbJXWWCrnVE0+t4s220uJ+pTHVKs=";
    })
    (fetchFromGitHub {
      owner = "NVIDIA";
      repo = "open-gpu-kernel-modules";
      name = "open-gpu";
      tag = "515.43.04";
      hash = "sha256-DBchPjpHpw4Gnzdvkdih6I1h0lxUu9jpexpOkQtZy24=";

      # since .git isn't declarative, we can't use it to checkout tags in the
      # build phase, so instead we generate patches for each version upgrade
      # before .git is removed and apply them incrementally
      fetchTags = true;
      postCheckout = ''
        cd $out

        cp ${./tags.txt} SOURCE_TAGS
        mkdir PATCHES

        prev_tag=515.43.04
        while IFS= read -r tag; do
          if [ "$prev_tag" == "$tag" ]; then continue; fi

          echo "generating patch: $prev_tag -> $tag"
          git diff --minimal --binary "$prev_tag" "$tag" > "PATCHES/$tag.patch"

          prev_tag=$tag
        done < SOURCE_TAGS
        unset prev_tag

        rm -rf .git
      '';
    })
  ];

  sourceRoot = ".";

  postUnpack = ''
    mv open-gpu nvibrant/
    cd nvibrant
  '';

  patches = [ ./hatch_build.patch ];

  build-system = with python3Packages; [
    hatchling
    meson
    ninja
  ];

  dependencies = with python3Packages; [ packaging ];

  nativeBuildInputs = [ git ];

  meta = with lib; {
    description = "Configure NVIDIA's Digital Vibrance on Wayland";
    homepage = "https://github.com/Tremeschin/nvibrant";
    license = licenses.gpl3Only;
    mainProgram = "nvibrant";
    maintainers = [ maintainers.mikaeladev ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
