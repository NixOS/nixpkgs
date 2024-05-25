{
  lib,
  stdenv,
  buildBazelPackage,
  fetchFromGitHub,
  bazel_6,
  jdk,
  git,
}:

buildBazelPackage rec {
  pname = "bant";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "bant";
    rev = "v${version}";
    hash = "sha256-3xGAznR/IHQHY1ISqmU8NxI90Pl57cdYeRDeLVh9L08=";
  };

  postPatch = ''
    patchShebangs scripts/create-workspace-status.sh
  '';

  fetchAttrs = {
    sha256 = "sha256-k9yCzs9atdBNMH4r2RF8TfHS3+p5u8u8oY9Zzl9c8dA=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ hzeller ];
    platforms = platforms.all;
  };
}
