{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  gawk,
}:

buildGoModule (finalAttrs: {
  pname = "goawk";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "goawk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Luz6boPGIJqF/PJHZmnu3zChT5g8Wt37eOMtFS7j2pI=";
  };

  vendorHash = null;

  nativeCheckInputs = [ gawk ];

  postPatch = ''
    substituteInPlace goawk_test.go \
      --replace "TestCommandLine" "SkipCommandLine" \
      --replace "TestDevStdout" "SkipDevStdout" \
      --replace "TestFILENAME" "SkipFILENAME" \
      --replace "TestWildcards" "SkipWildcards"

    substituteInPlace interp/interp_test.go \
      --replace "TestShellCommand" "SkipShellCommand"
  '';

  checkFlags = [
    "-awk"
    "${gawk}/bin/gawk"
  ];

  doCheck = (stdenv.system != "aarch64-darwin");

  meta = {
    description = "POSIX-compliant AWK interpreter written in Go";
    homepage = "https://benhoyt.com/writings/goawk/";
    license = lib.licenses.mit;
    mainProgram = "goawk";
    maintainers = with lib.maintainers; [ abbe ];
  };
})
