{ stdenv, lib, python3 }:

stdenv.mkDerivation {
  name = "replace-secret";
  buildInputs = [ python3 ];
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    install -D ${./replace-secret.py} $out/bin/replace-secret
    patchShebangs $out
    runHook postInstall
  '';
  installCheckPhase = ''
    install -m 0600 ${./test/input_file} long_test
    $out/bin/replace-secret "replace this" ${./test/passwd} long_test
    $out/bin/replace-secret "and this" ${./test/rsa} long_test
    diff ${./test/expected_long_output} long_test

    install -m 0600 ${./test/input_file} short_test
    $out/bin/replace-secret "replace this" <(echo "a") short_test
    $out/bin/replace-secret "and this" <(echo "b") short_test
    diff ${./test/expected_short_output} short_test
  '';
  meta = with lib; {
    platforms = platforms.all;
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Replace a string in one file with a secret from a second file";
    longDescription = ''
      Replace a string in one file with a secret from a second file.

      Since the secret is read from a file, it won't be leaked through
      '/proc/<pid>/cmdline', unlike when 'sed' or 'replace' is used.
    '';
    mainProgram = "replace-secret";
  };
}
