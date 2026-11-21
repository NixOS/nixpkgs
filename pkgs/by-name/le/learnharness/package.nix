{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "learnharness";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/amosblomqvist/learnharness/releases/download/v${version}/LearnHarness-${version}-x86_64.AppImage";
    hash = "sha256-uKAz63QhZ3iT2W5JiLMBU/3+T8bw3EVveUcWG7oEG5g=";
  };

  meta = with lib; {
    description = "LearnHarness uses AI agents to plan and teach lessons from your current understanding to your goal.";
    homepage = "https://github.com/amosblomqvist/learnharness";
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ tiagoflopes ];
  };
}
