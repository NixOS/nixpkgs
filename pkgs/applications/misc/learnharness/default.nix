{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "learnharness";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/amosblomqvist/learnharness/releases/download/v${version}/LearnHarness-${version}-x86_64.AppImage";
    hash = "sha256-tb2EmK1TyiqOtwgHNK8OxaquwbtqxV8kboUCnMumncM=";
  };

  meta = with lib; {
    description = "LearnHarness uses AI agents to plan and teach lessons from your current understanding to your goal.";
    homepage = "https://github.com/amosblomqvist/learnharness";
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ "tiagoflopes" ];
  };
}
