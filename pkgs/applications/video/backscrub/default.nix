{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, opencv
, cmake
, tensorflow-lite
, flatbuffers
, abseil-cpp
}:
stdenv.mkDerivation rec{
  pname = "backscrub";
  version = "0.3.0";
  src = fetchFromGitHub {
    repo = pname;
    owner = "floe";
    rev = "v${version}";
    sha256 = "sha256-ad5arFE8JdouWvrjCwYPO34X+sDixwGfQnEUA2FUV2s=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ opencv tensorflow-lite ];
  # dontConfigure = true;

  postPatch =
    ''
      # mkdir -p tensorflow/tensorflow
      # cp -a ${tensorflow-lite.src}/* tensorflow
      pushd tensorflow
      ${lib.strings.concatMapStringsSep "\n" (patch:"patch -p1 < ${patch}") tensorflow-lite.patches}
      ${tensorflow-lite.postPatch}
      ${tensorflow-lite.preBuild}
      popd
    '';
}

