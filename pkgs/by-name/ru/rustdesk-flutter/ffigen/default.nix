{
  buildDartApplication,
  fetchFromGitHub,
  lib,
  flutter,
}:

buildDartApplication rec {
  pname = "ffigen";
  version = "8.0.2"; # According to https://github.com/rustdesk/rustdesk/blob/master/build.py#L173. We should use 5.0.1. But It can't run on flutter324. So I found another old version.

  src = fetchFromGitHub {
    owner = "dart-lang";
    repo = "native";
    tag = "ffigen-v${version}";
    hash = "sha256-TUtgdT8huyo9sharIMHZ998UzzfMq2gj9Q9aspXYumU=";
  };

  postBuild = ''
    mkdir -p $out/bin
    ln -s ${flutter}/bin/dart $out/bin/dart
  '';

  sourceRoot = "${src.name}/pkgs/ffigen";
  pubspecLock = lib.importJSON ./ffigen.pubspec.lock.json;
  dartEntryPoints."bin/ffigen" = "bin/ffigen.dart";

  meta.mainProgram = "ffigen";
  meta.license = lib.licenses.bsd3;
}
