{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_6,
  jdk,
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
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-4h76ok2aN7WfD8OHIS0O2Dk924+hFXJXewKRM7XYjKw=";
  };

  bazelFlags = ["--registry" "file://${registry}"];

  postPatch = ''
    patchShebangs scripts/create-workspace-status.sh
  '';

  fetchAttrs = {
    sha256 = {
      aarch64-linux = "sha256-38O9HPKMjqpNCO+kC8hUlsJAclONVCj3oj/iVRwOEDo=";
      x86_64-linux = "sha256-OUVjgVIBNh0j10dgk/l42bqmsGuBC56uf4Ei/IRXxBI=";
    }.${system} or (throw "No hash for system: ${system}");
  };

  nativeBuildInputs = [
    jdk
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
