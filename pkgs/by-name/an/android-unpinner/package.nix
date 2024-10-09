{ lib
, buildPythonPackage
, fetchFromGitHub
, rich
, rich-click
, android-tools
, aapt
, apksigner
, androidenv
}:
let
  buildToolsVersion = "33.0.2";
  build-tools = androidenv.composeAndroidPackages {
    buildToolsVersions = [ buildToolsVersion ];
  };
  zipalign = "${build-tools.androidsdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/zipalign";
in
buildPythonPackage rec {
  pname = "android-unpinner";
  version = "2bc31d94c3fe296457e2d7bf2120220de16ca839";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "android-unpinner";
    rev = version;
    hash = "sha256-6EHd0CkJ1zlnjWUjDvYaehv3IfqlryKzOsxglPoZiog=";
  };

  propagatedBuildInputs = [ rich rich-click ];

  patchPhase = ''
    runHook prePatch

    # use nixpkgs adb as opposed to vendored platform_tools adb
    substituteInPlace android_unpinner/vendor/platform_tools/__init__.py \
      --replace "{adb_binary}" ${lib.getExe' android-tools "adb"}

    # replace build_tools too
    substituteInPlace android_unpinner/vendor/build_tools/__init__.py \
      --replace "aapt2_binary," "'${lib.getExe aapt}'," \
      --replace "apksigner_binary," "'${lib.getExe apksigner}'," \
      --replace "zipalign_binary," "'${zipalign}'," \
      --replace 'here / "android-unpinner.jks"' "'${src}/android_unpinner/vendor/build_tools/android-unpinner.jks'"

    # vendored gadgets
    substituteInPlace android_unpinner/vendor/__init__.py \
      --replace "Path(__file__).absolute().parent" "Path('${src}/android_unpinner/vendor')"

    # vendored scripts
    substituteInPlace android_unpinner/__main__.py \
      --replace "Path(__file__).absolute().parent" "Path('${src}/android_unpinner')"

    runHook postPatch
  '';

  meta = with lib; {
    homepage = "https://github.com/mitmproxy/android-unpinner";
    description = "Android Certificate Pinning Unpinner";
    longDescription = ''
      Tool that removes certificate pinning from APKs without requiring root.
    '';
    license = with licenses; mit;
    maintainers = with maintainers; [ mib ];
  };
}
