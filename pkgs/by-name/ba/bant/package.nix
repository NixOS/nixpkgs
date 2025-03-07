{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_6,
  jdk,
  git,
}:

let
  system = stdenv.hostPlatform.system;
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "1c729c2775715fd98f0f948a512eb173213250da";
    hash = "sha256-1iaDDM8/v8KCOUjPgLUtZVta7rMzwlIK//cCoLUrb/s=";
  };
in buildBazelPackage rec {
  pname = "bant";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-3xGAznR/IHQHY1ISqmU8NxI90Pl57cdYeRDeLVh9L08=";
  };

  bazelFlags = ["--registry" "file://${registry}"];

  postPatch = ''
    patchShebangs scripts/create-workspace-status.sh
  '';

  fetchAttrs = {
    sha256 = {
      aarch64-linux = "sha256-jtItWNfl+ebQqU8VWmvLsgNYNARGxN8+CTBz2nZcBEY=";
      x86_64-linux = "sha256-ACJqybpHoMSg2ApGWkIyhdAQjIhb8gxUdo8SuWJvTNE=";
    }.${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [
    jdk
    git
  ];
  bazel = bazel_6;

  bazelBuildFlags = [ "-c opt" ];
  bazelTestTargets = [ "//..." ];
  bazelTargets = [ "//bant:bant" ];

  buildAttrs = {
    installPhase = ''
      install -D --strip bazel-bin/bant/bant "$out/bin/bant"
    '';
  };

  meta = with lib; {
    description = "Bazel/Build Analysis and Navigation Tool";
    homepage = "http://bant.build/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ hzeller lromor ];
    platforms = platforms.linux;
  };
}
