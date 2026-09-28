{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  gawk,
}:

buildGoModule (finalAttrs: {
  pname = "goawk";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "goawk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eYybVWqaN9iSoMe2HG0dOyzaYZOmYJsV8RN1Q2w2L6w=";
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
