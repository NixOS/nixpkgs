{ pkgs, lib, callPackage, runCommand }:
{

  /* Checks that two packages produce the exact same build instructions.

     This can be used to make sure that a certain difference of configuration,
     such as the presence of an overlay does not cause a cache miss.

     When the derivations are equal, the return value is an empty file.
     Otherwise, the build log explains the difference via `nix-diff`.

     Example:

         testEqualDerivation
           "The hello package must stay the same when enabling checks."
           hello
           (hello.overrideAttrs(o: { doCheck = true; }))
  */
  testEqualDerivation = callPackage ./test-equal-derivation.nix { };

  /* Checks the command output contains the specified version

     Although simplistic, this test assures that the main program
     can run. While there's no substitute for a real test case,
     it does catch dynamic linking errors and such. It also provides
     some protection against accidentally building the wrong version,
     for example when using an 'old' hash in a fixed-output derivation.

     Examples:

       passthru.tests.version = testVersion { package = hello; };

       passthru.tests.version = testVersion {
         package = seaweedfs;
         command = "weed version";
       };

       passthru.tests.version = testVersion {
         package = key;
         command = "KeY --help";
         # Wrong '2.5' version in the code. Drop on next version.
         version = "2.5";
       };
  */
  testVersion =
    { package,
      command ? "${package.meta.mainProgram or package.pname or package.name} --version",
      version ? package.version,
    }: runCommand "${package.name}-test-version" { nativeBuildInputs = [ package ]; meta.timeout = 60; } ''
      if output=$(${command} 2>&1); then
        grep -Fw "${version}" - <<< "$output"
        touch $out
      else
        echo "$output" >&2 && exit 1
      fi
    '';
}
