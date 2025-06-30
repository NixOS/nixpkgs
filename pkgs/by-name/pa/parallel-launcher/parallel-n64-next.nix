{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libretro,
}:
let
  # Converts a version string like x.y.z to vx.y-z
  reformatVersion = v: "v${lib.versions.majorMinor v}-${lib.versions.patch v}";
in
libretro.parallel-n64.overrideAttrs (
  final: prev: {
    pname = "${prev.pname}-next";
    version = "2.24.0";

    src = fetchFromGitLab {
      owner = "parallel-launcher";
      repo = "parallel-n64";
      tag = reformatVersion final.version;
      hash = "sha256-fRvwn003KHsIKTBFtZhleA6yofxbUS1F3Z10j9gyfMg=";
    };

    installPhase =
      let
        suffix = stdenv.hostPlatform.extensions.sharedLibrary;
      in
      ''
        runHook preInstall

        install -Dm644 parallel_n64_libretro${suffix} $out/lib/retroarch/cores/parallel_n64_next_libretro${suffix}

        runHook postInstall
      '';

    nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [
      pkg-config
    ];

    makeFlags = (prev.makeFlags or [ ]) ++ [
      "HAVE_THR_AL=1"
      "SYSTEM_LIBPNG=1"
      "SYSTEM_ZLIB=1"
    ];
  }
)
