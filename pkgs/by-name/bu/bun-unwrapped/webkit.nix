{ fetchgit }:

fetchgit {
  name = "bun-webkit-source";
  url = "https://github.com/oven-sh/WebKit.git";
  rev = "0f966e81b78c84bb23213e391bc679c4ef83e56b";
  hash = "sha256-SoW16cPTTHicOdnSpO+hWXeGNg7/3FmecILrJIcBPkU=";

  # GitHub cannot generate archives for this repository. Keep only the
  # directories needed by WebKit's JSCOnly CMake build.
  sparseCheckout = [
    "Configurations"
    "Source/cmake"
    "Source/JavaScriptCore"
    "Source/WTF"
    "Source/bmalloc"
    "Source/ThirdParty/capstone"
    "Source/ThirdParty/gmock"
    "Source/ThirdParty/gtest"
    "Source/ThirdParty/unifdef"
    "Source/ThirdParty/xdgmime"
    "Tools/Scripts"
    "WebKitLibraries"
  ];
}
