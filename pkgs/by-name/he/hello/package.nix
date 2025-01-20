{ mkPackage }:
mkPackage (
  {
    stdenv,
    fetchurl,
    testers,
    layers,
    lib,
    callPackage,
    versionCheckHook,
  }:
  [
    (layers.derivation { inherit stdenv; })
    (this: old: {
      name = "hello";
      version = "2.12.1";

      setup = old.setup or { } // {
        src = fetchurl {
          url = "mirror://gnu/hello/hello-${this.version}.tar.gz";
          hash = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2Idh9RLibH2yA=";
        };

        doCheck = true;
        doInstallCheck = true;
        nativeInstallCheckInputs = [
          versionCheckHook
        ];

        # Give hello some install checks for testing purpose.
        postInstallCheck = ''
          stat "''${!outputBin}/bin/${this.meta.mainProgram}"
        '';
      };

      # The GNU Hello `configure` script detects how to link libiconv but fails to actually make use of that.
      # Unfortunately, this cannot be a patch to `Makefile.am` because `autoreconfHook` causes a gettext
      # infrastructure mismatch error when trying to build `hello`.
      env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
        NIX_LDFLAGS = "-liconv";
      };

      public = old.public // {
        tests = {
          version = testers.testVersion { package = this.public; };

          run = callPackage ./test.nix { hello = this.public; };
        };
        # Other packages and tests expect to reuse our src
        /**
          Fetched sources of GNU hello
        */
        inherit (this.setup) src;
      };

      meta = {
        description = "Program that produces a familiar, friendly greeting";
        longDescription = ''
          GNU Hello is a program that prints "Hello, world!" when you run it.
          It is fully customizable.
        '';
        homepage = "https://www.gnu.org/software/hello/manual/";
        changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${this.version}";
        license = lib.licenses.gpl3Plus;
        maintainers = with lib.maintainers; [ stv0g ];
        mainProgram = "hello";
        platforms = lib.platforms.all;
      };
    })
  ]
)
