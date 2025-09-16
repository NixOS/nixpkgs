{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libsignal-ffi,
  versionCheckHook,
}:

let
  cppStdLib = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";
in
buildGoModule rec {
  pname = "mautrix-signal";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    tag = "v${version}";
    hash = "sha256-62Z7Lasx0bzCAWLvHN7uCUqkMk6W80PR24mwfJU/n3Q=";
  };

  buildInputs = [
    stdenv.cc.cc.lib

    # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
    # see https://github.com/mautrix/signal/issues/401
    libsignal-ffi
  ];

  tags = "goolm";

  CGO_LDFLAGS = [ cppStdLib ];

  vendorHash = "sha256-srvqflqleK2KIgesEZPNhSQh/IFmyTElJ7iUjBEmNq0=";

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
