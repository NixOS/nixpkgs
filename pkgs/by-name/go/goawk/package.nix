{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  gawk,
}:

buildGoModule rec {
  pname = "goawk";
<<<<<<< HEAD
  version = "1.31.0";
=======
  version = "1.30.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "goawk";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Luz6boPGIJqF/PJHZmnu3zChT5g8Wt37eOMtFS7j2pI=";
=======
    hash = "sha256-143KcCeZOwn3FkAtpPkfbyTupYCWw2R+tD7R3ldla6I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "POSIX-compliant AWK interpreter written in Go";
    homepage = "https://benhoyt.com/writings/goawk/";
    license = lib.licenses.mit;
    mainProgram = "goawk";
    maintainers = with lib.maintainers; [ abbe ];
=======
  meta = with lib; {
    description = "POSIX-compliant AWK interpreter written in Go";
    homepage = "https://benhoyt.com/writings/goawk/";
    license = licenses.mit;
    mainProgram = "goawk";
    maintainers = with maintainers; [ abbe ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
