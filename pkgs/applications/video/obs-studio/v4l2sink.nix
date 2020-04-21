{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, qtbase
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-v4l2sink";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "CatxFish";
    repo = "obs-v4l2sink";
    rev = version;
    sha256 = "0l4lavaywih5lzwgxcbnvdrxhpvkrmh56li06s3aryikngxwsk3z";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase obs-studio ];

  patches = [
    # Fixes the segfault when stopping the plugin
    (fetchpatch {
      url = "https://github.com/CatxFish/obs-v4l2sink/commit/6604f01796d1b84a95714730ea51a6b8ac0e450b.diff";
      sha256 = "0crcvw02dj0aqy7hnhizjdsnhiw03zmg6cbdkasxz2mrrbyc3s88";
    })
  ];

  cmakeFlags = with lib; [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
  ];

  # obs-studio expects the shared object to be located in bin/32bit or bin/64bit
  # https://github.com/obsproject/obs-studio/blob/d60c736cb0ec0491013293c8a483d3a6573165cb/libobs/obs-nix.c#L48
  postInstall = let
    pluginPath = {
      i686-linux = "bin/32bit";
      x86_64-linux = "bin/64bit";
    }.${stdenv.targetPlatform.system} or (throw "Unsupported system: ${stdenv.targetPlatform.system}");
  in ''
    mkdir -p $out/share/obs/obs-plugins/v4l2sink/${pluginPath}
    ln -s $out/lib/obs-plugins/v4l2sink.so $out/share/obs/obs-plugins/v4l2sink/${pluginPath}
  '';

  meta = with lib; {
    description = "obs studio output plugin for Video4Linux2 device";
    homepage = "https://github.com/CatxFish/obs-v4l2sink";
    maintainers = with maintainers; [ colemickens peelz ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
