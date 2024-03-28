{ mkPackageWithDeps, layers }: mkPackageWithDeps ({ stdenv, fetchurl, testers, lib, callPackage, nixos }: [
  (layers.derivation { inherit stdenv; })
  (this: old: {
    name = "hello";
    version = "2.12.1";

    setup = old.setup or {} // {
      src = fetchurl {
        url = "mirror://gnu/hello/hello-${this.version}.tar.gz";
        sha256 = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2Idh9RLibH2yA=";
      };
      doCheck = true;
    };

    tests = {
      version = testers.testVersion { package = this.public; };

      invariant-under-noXlibs =
        testers.testEqualDerivation
          "hello must not be rebuilt when environment.noXlibs is set."
          this.public
          (nixos { environment.noXlibs = true; }).pkgs.hello;

      run = callPackage ./test.nix { hello = this.public; };
    };

    meta = with lib; {
      description = "A program that produces a familiar, friendly greeting";
      longDescription = ''
        GNU Hello is a program that prints "Hello, world!" when you run it.
        It is fully customizable.
      '';
      homepage = "https://www.gnu.org/software/hello/manual/";
      changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${this.version}";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.eelco ];
      mainProgram = "hello";
      platforms = platforms.all;
    };
  })
])
