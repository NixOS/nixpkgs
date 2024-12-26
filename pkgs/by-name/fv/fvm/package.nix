{
  buildDartApplication,
  clang,
  pkg-config,
  gtk3,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  lib,
}:

buildDartApplication rec {
  pname = "fvm";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "leoafarias";
    repo = pname;
    tag = version;
    hash = "sha256-i7sJRBrS5qyW8uGlx+zg+wDxsxgmolTMcikHyOzv3Bs=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    clang
    pkg-config
    gtk3
    cmake
  ];

  shellHook = ''
    export PKG_CONFIG_PATH=${gtk3.dev}/lib/pkgconfig
    export LD_LIBRARY_PATH=${gtk3.out}/lib:$LD_LIBRARY_PATH
  '';

  dontUseCmakeConfigure = true;

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Flutter Version Management: A simple CLI to manage Flutter SDK versions.";
    homepage = "https://fvm.app";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.MH0386 ];
  };
}
