{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libsignal-ffi,
  zlib,
  versionCheckHook,
}:

let
  cppStdLib = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";
in
buildGoModule rec {
  pname = "mautrix-signal";
  version = "25.10";
  tag = "v0.2510.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    tag = tag;
    hash = "sha256-Bz4jBI/lLhCxZW7JmaX6dlVwbB3dLXn5v/8gMKcFKSE=";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
    zlib
  ];

  tags = "goolm";

  CGO_LDFLAGS = cppStdLib;

  vendorHash = "sha256-Sur29i5ih7xK85maVAaq9cwWJVGtwS7hPOxQI4YduNI=";

  ldflags = [
    "-X"
    "main.Tag=${tag}"
  ];

  doCheck = true;
  preCheck = ''
    # Needed by the tests to be able to find libstdc++
    export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
  '';

  postCheck = ''
    unset LD_LIBRARY_PATH
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      pentane
      ma27
      SchweGELBin
    ];
    mainProgram = "mautrix-signal";
  };
}
