{ callPackage
, lib
, stdenv
, fetchurl
, nixos
, testers
, salve-mundi
, makeWrapper
, runCommand
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "salve-mundi";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2Idh9RLibH2yA=";
  };

  doCheck = true;


  /* Wrap the program */

  postInstall = lib.optionalString (finalAttrs.passthru.greeting != null) ''
    wrapProgram $out/bin/hello --append-flags --greeting=${lib.escapeShellArg (lib.escapeShellArg finalAttrs.passthru.greeting)}
  '';
  nativeBuildInputs = [ makeWrapper ];
  passthru.greeting = "SALVE MUNDI";


  /* Tidy up the package attributes and make them useful */

  __cleanAttrs = true;
  passthru.exe = lib.getExe finalAttrs.finalPackage;
  # We allow `hello.src` to be used in tests and examples, despite __cleanAttrs
  passthru.src = finalAttrs.src;


  /* Strict deps enforce a separation of concerns that also benefits cross compilation
     and, for shells, shell completions support via nativeBuildInputs */

  strictDeps = true;


  /* A fairly extensive suite of extra tests that we like to hold either for
     the package in the Nixpkgs package set, or even for all possible overrides
     of the package. */

  passthru.tests = {
    version = testers.testVersion { package = salve-mundi; };

    # We use Nixpkgs attributes instead of `finalAttrs.finalPackage` here
    # because overriding is not supported. Running the test on an overridden
    # finalPackage wouldn't work, and is a bit unnecessary anyway.
    invariant-under-noXlibs =
      testers.testEqualDerivation
        "hello must not be rebuilt when environment.noXlibs is set."
        salve-mundi
        (nixos { environment.noXlibs = true; }).pkgs.salve-mundi;

    run = runCommand "salve-mundi-test-run" {
      nativeBuildInputs = [ finalAttrs.finalPackage ];
    } ''
      diff -U3 --color=auto <(hello) <(echo 'SALVE MUNDI')
      touch $out
    '';

    restore-default-greeting = callPackage ./test.nix {
      hello = finalAttrs.finalPackage.overrideAttrs (o: {
        passthru = o.passthru // {
          greeting = null;
        };
      });
    };
  };

  meta = with lib; {
    description = "A showcase of Nixpkgs features that produces an unfamiliar, archaic greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable. This package proves it, and showcases some
      of the fancier things you can do with Nixpkgs.
    '';
    mainProgram = "hello";
    homepage = "https://www.gnu.org/software/hello/manual/";
    changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${finalAttrs.version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.roberth ];
    platforms = platforms.all;
  };
})
