{ lib, fetchFromGitHub, buildLua, mpv-unwrapped }:

buildLua {
  pname = "mpv-thumbfast";
  version = "unstable-2023-06-04";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "4241c7daa444d3859b51b65a39d30e922adb87e9";
    hash = "sha256-7EnFJVjEzqhWXAvhzURoOp/kad6WzwyidWxug6u8lVw=";
  };

  postPatch = ''
    substituteInPlace thumbfast.lua \
      --replace 'mpv_path = "mpv"' 'mpv_path = "${lib.getExe mpv-unwrapped}"'
  '';

  scriptPath = "thumbfast.lua";

  meta = {
    description = "High-performance on-the-fly thumbnailer for mpv";
    homepage = "https://github.com/po5/thumbfast";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
